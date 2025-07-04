import 'dart:ui';
import 'package:carma/common/data/models/financial_type_model.dart';
import 'package:carma/core/constants/constants.dart';
import 'package:carma/core/db/db_helper.dart';
import 'package:carma/core/errors/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

abstract class InitializationDataSource {
  Future<Either<Failure, void>> initializeCategories();
}

class InitializationDataSourceImpl extends InitializationDataSource {
  DbHelper dbHelper;

  InitializationDataSourceImpl(this.dbHelper);

  final List<Color> expenseColors = [
    Colors.red,
    Colors.orange,
    Colors.yellow,
    Colors.green,
    Colors.blue,
    Colors.indigo,
    Colors.purple,
    Colors.blueGrey,
    Colors.brown,
    Colors.cyan,
    Colors.teal,
    Colors.lime,
    Colors.pinkAccent,
    Colors.amber,
    Colors.deepOrangeAccent,
    Colors.pink,
    Colors.deepOrange,
    Colors.lightGreen,
    Colors.deepPurple,
    Colors.grey,
    Colors.lightBlueAccent,
    Colors.lightBlue,
    Colors.black,
    Colors.white,
    Colors.blueAccent,
    Colors.deepPurpleAccent,
    Colors.orangeAccent,
    Colors.greenAccent,
    Colors.redAccent,
  ];
  final List<Color> incomeColors = [
    Colors.lightBlue,
    Colors.lightGreen,
    Colors.amber,
    Colors.cyan,
    Colors.teal,
    Colors.pink,
  ];

  late List<FinancialTypeModel> expenses;
  late List<FinancialTypeModel> incomes;

  @override
  Future<Either<Failure, void>> initializeCategories() async {
    // TODO: Check SP before querying from db

    final result = await dbHelper.getCategoriesCount();

    print('initialize check is this');
    print(result);
    print(result.length);
    print(result.isEmpty);
    print((result[0]['total_categories'] ?? 0) != 0);

    if ((result[0]['total_categories'] ?? 0) != 0) {
      return const Right(unit);
    }

    // Insert Categories

    expenses = [
      FinancialTypeModel(
          label: 'Fuel', isSelected: false, imageAsset: 'assets/images/fuel.png', indicatedColor: expenseColors[0]),
      FinancialTypeModel(
          label: 'Tire Pressure',
          isSelected: false,
          imageAsset: 'assets/images/tire_pressure.png',
          indicatedColor: expenseColors[1]),
      FinancialTypeModel(
        label: 'Tolls',
        isSelected: false,
        imageAsset: 'assets/images/tolls.png',
        indicatedColor: expenseColors[2],
      ),
      FinancialTypeModel(
        label: 'Fine',
        isSelected: false,
        indicatedColor: expenseColors[3],
        imageAsset: 'assets/images/fine.png',
      ),
      FinancialTypeModel(
        label: 'Parking',
        isSelected: false,
        imageAsset: 'assets/images/parking.png',
        indicatedColor: expenseColors[4],
      ),
      FinancialTypeModel(
          label: 'Financing',
          isSelected: false,
          imageAsset: 'assets/images/financing.png',
          indicatedColor: expenseColors[5]),
      FinancialTypeModel(
          label: 'Paper Work',
          isSelected: false,
          imageAsset: 'assets/images/paper_work.png',
          indicatedColor: expenseColors[6]),
      FinancialTypeModel(
        label: 'Tax',
        isSelected: false,
        imageAsset: 'assets/images/tax.png',
        indicatedColor: expenseColors[7],
      ),
      // -- Service --
      FinancialTypeModel(
        label: 'AC',
        isSelected: false,
        imageAsset: 'assets/images/AC.png',
        indicatedColor: expenseColors[8],
      ),
      FinancialTypeModel(
          label: 'Air Filter',
          isSelected: false,
          imageAsset: 'assets/images/air_filter.png',
          indicatedColor: expenseColors[9]),
      FinancialTypeModel(
        label: 'Battery',
        isSelected: false,
        imageAsset: 'assets/images/battery.png',
        indicatedColor: expenseColors[10],
      ),
      FinancialTypeModel(
        label: 'Belts',
        isSelected: false,
        indicatedColor: expenseColors[11],
        imageAsset: 'assets/images/belts.png',
      ),
      FinancialTypeModel(
          label: 'Brake Fluid',
          isSelected: false,
          imageAsset: 'assets/images/brake_fluid.png',
          indicatedColor: expenseColors[12]),
      FinancialTypeModel(
          label: 'Car Wash',
          isSelected: false,
          imageAsset: 'assets/images/car_wash.png',
          indicatedColor: expenseColors[13]),
      FinancialTypeModel(
          label: 'Fuel Filter',
          isSelected: false,
          imageAsset: 'assets/images/fuel_filter.png',
          indicatedColor: expenseColors[14]),
      FinancialTypeModel(
          label: 'Inspection',
          isSelected: false,
          imageAsset: 'assets/images/inspection.png',
          indicatedColor: expenseColors[15]),
      FinancialTypeModel(
          label: 'Labor Cost',
          isSelected: false,
          imageAsset: 'assets/images/labor_cost.png',
          indicatedColor: expenseColors[16]),
      FinancialTypeModel(
        label: 'Lights',
        isSelected: false,
        imageAsset: 'assets/images/lights.png',
        indicatedColor: expenseColors[17],
      ),
      FinancialTypeModel(
          label: 'New Tires',
          isSelected: false,
          imageAsset: 'assets/images/new_tires.png',
          indicatedColor: expenseColors[18]),
      FinancialTypeModel(
          label: 'Oil Change',
          isSelected: false,
          imageAsset: 'assets/images/oil_change.png',
          indicatedColor: expenseColors[19]),
      FinancialTypeModel(
          label: 'Oil Filter',
          isSelected: false,
          imageAsset: 'assets/images/oil_filter.png',
          indicatedColor: expenseColors[20]),
      FinancialTypeModel(
          label: 'Rotate Tires',
          isSelected: false,
          imageAsset: 'assets/images/rotate_tires.png',
          indicatedColor: expenseColors[21]),
      FinancialTypeModel(
          label: 'Suspension',
          isSelected: false,
          imageAsset: 'assets/images/suspension.png',
          indicatedColor: expenseColors[22]),
      FinancialTypeModel(
          label: 'Alignments',
          isSelected: false,
          imageAsset: 'assets/images/alignments.png',
          indicatedColor: expenseColors[23]),
      FinancialTypeModel(
        label: 'Others',
        isSelected: false,
        indicatedColor: expenseColors[24],
        imageAsset: 'assets/images/others.png',
      ),
    ];
    incomes = [
      FinancialTypeModel(
        label: 'Freight',
        isSelected: false,
        indicatedColor: incomeColors[0],
        imageAsset: 'assets/images/freight.png',
      ),
      FinancialTypeModel(
        label: 'Refund',
        isSelected: false,
        indicatedColor: incomeColors[1],
        imageAsset: 'assets/images/refund.png',
      ),
      FinancialTypeModel(
        label: 'Ride',
        isSelected: false,
        indicatedColor: incomeColors[2],
        imageAsset: 'assets/images/ride.png',
      ),
      FinancialTypeModel(
        label: 'Others',
        isSelected: false,
        indicatedColor: incomeColors[5],
        imageAsset: 'assets/images/others.png',
      ),
    ];

    for (int i = 0; i < expenses.length; i++) {
      int rowsAffected = await dbHelper.insertCategory(
        name: expenses[i].label,
        type: Constants.TYPE_EXPENSE,
        imageAsset: expenses[i].imageAsset,
        color: expenses[i].indicatedColor,
      );
      print('rows affected expenses $rowsAffected');
      if (rowsAffected == 0) {
        return const Left(GeneralFailure('An error has occurred'));
      }
    }

    for (int i = 0; i < incomes.length; i++) {
      int rowsAffected = await dbHelper.insertCategory(
        name: incomes[i].label,
        imageAsset: incomes[i].imageAsset,
        type: Constants.TYPE_INCOME,
        color: incomeColors[i],
      );
      print('rows affected incomes $rowsAffected');
      if (rowsAffected == 0) {
        return const Left(GeneralFailure('An error has occurred'));
      }
    }

    return const Right(unit);
  }
}
