import 'dart:io';

import 'package:carma/core/utils/Utils.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DbHelper {
  static Database? _database;

  // Singleton pattern to ensure only one instance of the database is created
  Future<Database> get database async {
    if (_database != null) return _database!;

    // If no database exists, create a new one
    _database = await _initDatabase();
    return _database!;
  }

  Future<void> restoreDatabase(File backupFile) async {
    try {
      final dbPath = await getDatabasesPath();
      final path = join(dbPath, 'app_database.db');

      // Backup file must exist
      if (await backupFile.exists()) {
        // Replace the current database with the backup
        await backupFile.copy(path);
        print('Database restored from backup');
      } else {
        throw Exception('Backup file does not exist');
      }
    } catch (e) {
      print('Error restoring database: $e');
      rethrow;
    }
  }

  // Initialize the database
  Future<Database> _initDatabase() async {
    print('creating db');
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'app_database.db'); // Path to the database file

    return await openDatabase(
      path,
      version: 1, // Set database version
      onCreate: _onCreate, // If the database doesn't exist, create it
    );
  }

  Future<File> getDatabaseBackupFile() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'app_database.db');
    return File(path);
  }

  // Create table in the database
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS transactions (
        id          INTEGER PRIMARY KEY AUTOINCREMENT,   -- Unique transaction ID
        amount      TEXT NOT NULL,                   -- Transaction amount (can be negative for expenses)
        category_id TEXT NOT NULL,                 -- Transaction category (e.g., Food, Transport, Salary, etc.)
        date        TEXT NOT NULL,                     -- Transaction date (stored as timestamp)
        time        TEXT NOT NULL,                     -- Transaction date (stored as timestamp)
        notes       TEXT,                       -- Optional description of the transaction
        type        TEXT NOT NULL,                     -- Type of transaction: 'expense' or 'income'
        created_at  INTEGER NOT NULL             -- Timestamp of when the transaction was created
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS categories (
        id          INTEGER PRIMARY KEY AUTOINCREMENT,
        color       TEXT NOT NULL,
        name        TEXT NOT NULL,
        image_asset TEXT NOT NULL,
        type        TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS odometer (
        id          INTEGER PRIMARY KEY AUTOINCREMENT,
        notes       TEXT NOT NULL,
        reading     TEXT NOT NULL,
        date        TEXT NOT NULL
      )
    ''');
  }

  Future<List<Map<String, dynamic>>> getMonthlyFinancials() async {
    final db = await database;

    return await db.rawQuery('''
      SELECT 
          strftime('%m', date) AS month_number,                  -- Extract the numeric month
          strftime('%Y', date) AS year,                         -- Extract the year
          CASE strftime('%m', date)                             -- Map numeric months to short names
              WHEN '01' THEN 'Jan'
              WHEN '02' THEN 'Feb'
              WHEN '03' THEN 'Mar'
              WHEN '04' THEN 'Apr'
              WHEN '05' THEN 'May'
              WHEN '06' THEN 'Jun'
              WHEN '07' THEN 'Jul'
              WHEN '08' THEN 'Aug'
              WHEN '09' THEN 'Sep'
              WHEN '10' THEN 'Oct'
              WHEN '11' THEN 'Nov'
              WHEN '12' THEN 'Dec'
          END AS month, 
          SUM(CASE WHEN type = '0' THEN amount ELSE 0 END) AS total_expenses,
          SUM(CASE WHEN type = '1' THEN amount ELSE 0 END) AS total_income
      FROM 
          transactions
      GROUP BY 
          strftime('%Y', date), 
          strftime('%m', date)  -- Group by year and numeric month
      ORDER BY 
          year, 
          month_number;

  ''');
  }

  Future<List<Map<String, dynamic>>> getLifetimeFinancials() async {
    final db = await database;

    return await db.rawQuery('''
      select total_expenses, total_income from 
      (
      select ifNull(sum(amount),0) total_expenses from transactions
      where type = 0
      ) a,
      (
      select ifNull(sum(amount),0) total_income from transactions
      where type = 1
      ) b
  ''');
  }

  Future<List<Map<String, dynamic>>> getCurrentMonthFinancials() async {
    final db = await database;

    print('first of current month is this: ${Utils.getFirstOfCurrentMonth()}');
    print('last of current month is this: ${Utils.getLastOfCurrentMonth()}');

    return await db.rawQuery('''
      select total_expenses, total_income from 
      (
      select ifNull(sum(amount),0) total_expenses from transactions
      where type = 0
      and date >= '${Utils.convertToIso8601(Utils.getFirstOfCurrentMonth())}'
      and date <= '${Utils.convertToIso8601(Utils.getLastOfCurrentMonth())}'
      ) a,
      (
      select ifNull(sum(amount),0) total_income from transactions
      where type = 1
      and date >= '${Utils.convertToIso8601(Utils.getFirstOfCurrentMonth())}'
      and date <= '${Utils.convertToIso8601(Utils.getLastOfCurrentMonth())}'
      ) b
  ''');
  }

  Future<int> insertOdometerReading({required String reading, required String date, required String notes}) async {
    final db = await database;
    final readingEntry = {
      'reading': reading,
      'notes': notes,
      'date': date,
    };
    return await db.insert('odometer', readingEntry);
  }

  Future<bool> deleteAllData() async {
    try {
      final db = await database;
      await db.delete('transactions');
      await db.delete('odometer');
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<List<Map<String, dynamic>>> getOdometerReadings() async {
    final db = await database;
    return await db.query('odometer', orderBy: 'id DESC');
  }

  Future<int> insertCategory(
      {required String name, required int type, required Color color, required String imageAsset}) async {
    final db = await database;
    final category = {
      'name': name,
      'type': type.toString(),
      'image_asset': imageAsset,
      'color': color.value.toString(),
    };
    return await db.insert('categories', category);
  }

  Future<List<Map<String, dynamic>>> getCategoriesByType(int type) async {
    final db = await database;
    return await db.query('categories', where: 'type = ?', whereArgs: [type.toString()]);
  }

  Future<List<Map<String, dynamic>>> getCategoriesCount() async {
    final db = await database;
    return await db.rawQuery('''
    SELECT COUNT(id) total_categories FROM categories
    ''');
  }

  Future<int> insertTransaction(Map<String, dynamic> transaction) async {
    final db = await database;
    return await db.insert('transactions', transaction);
  }

  Future<List<Map<String, dynamic>>> getTransactions() async {
    final db = await database;
    return await db.rawQuery('''
    select a.id, a.amount, a.category_id, b.name as category_name, b.image_asset as image_asset, a.date, a.time, a.notes, a.type
    from transactions a, categories b
    where a.category_id = b.id
    order by a.date desc
    ''');
  }

  Future<List<Map<String, dynamic>>> getCategoryWiseAmounts(int type, String fromDate, String toDate) async {
    // print('fromDate $fromDate');
    // print('toDate $toDate');

    // TODO: change id
    final db = await database;
    return await db.rawQuery('''
    SELECT b.name as name, b.color as color, b.image_asset as image_asset, SUM(CAST(a.amount AS INTEGER)) AS total_amount
    FROM transactions a, categories b
    WHERE a.category_id = b.id
    AND a.type = '$type'
    AND a.date >= '${Utils.convertToIso8601(fromDate)}'
    AND a.date <= '${Utils.convertToIso8601(toDate)}'
    GROUP BY b.color
    ORDER BY total_amount desc
  ''');
  }

  // READ: Get a single transaction by ID
  Future<Map<String, dynamic>?> getTransactionById(int id) async {
    final db = await database;
    final result = await db.query(
      'transactions',
      where: 'id = ?',
      whereArgs: [id],
    );
    return result.isNotEmpty ? result.first : null;
  }

  Future<bool> deleteTransactionById(int id) async {
    final db = await database;
    final result = await db.delete(
      'transactions',
      where: 'id = ?',
      whereArgs: [id],
    );
    return result > 0;
  }

  // Close the database
  Future<void> close() async {
    final db = await database;
    db.close();
  }
}
