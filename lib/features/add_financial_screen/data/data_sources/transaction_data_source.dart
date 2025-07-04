import 'package:carma/core/db/db_helper.dart';
import 'package:carma/core/errors/failure.dart';
import 'package:carma/core/utils/Utils.dart';
import 'package:carma/features/add_financial_screen/data/models/current_month_financial_model.dart';
import 'package:carma/features/add_financial_screen/data/models/transaction_model.dart';
import 'package:dartz/dartz.dart';

abstract class TransactionDataSource {
  Future<Either<Failure, void>> saveTransaction(TransactionModel model);

  Future<Either<Failure, List<TransactionModel>>> getTransactions();

  Future<Either<Failure, bool>> deleteTransaction(TransactionModel model);

  Future<Either<Failure, CurrentMonthFinancialModel>>
      getCurrentMonthFinancials();
}

class TransactionDataSourceImpl extends TransactionDataSource {
  final DbHelper dbHelper;

  TransactionDataSourceImpl(this.dbHelper);

  @override
  Future<Either<Failure, void>> saveTransaction(TransactionModel model) async {
    try {
      // print('inserting check ${model.date}');
      // print('inserting check ${Utils.convertToIso8601(model.date)}');
      await dbHelper.insertTransaction({
        'amount': model.amount,
        'category_id': model.categoryId,
        'date': Utils.convertToIso8601(model.date),
        'time': model.time,
        'notes': model.notes,
        'type': model.type,
        'created_at': DateTime.now().millisecondsSinceEpoch,
      });

      return const Right(unit);
    } catch (e) {
      print(e);
      return const Left(GeneralFailure('Unable to insert transaction'));
    }
  }

  @override
  Future<Either<Failure, List<TransactionModel>>> getTransactions() async {
    try {
      String fromDate = Utils.getFirstOfCurrentMonth();
      String toDate = Utils.getLastOfCurrentMonth();
      final rawTransactions = await dbHelper.getTransactions();
      final transactions =
          rawTransactions.map((raw) => TransactionModel.fromJson(raw)).toList();
      print(transactions);
      return Right(transactions);
    } catch (e) {
      print(e);
      return const Left(GeneralFailure('Unable to load transactions'));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteTransaction(
      TransactionModel model) async {
    try {
      if (model.id == null) {
        return const Left(GeneralFailure('An error occurred'));
      }
      final result = await dbHelper.deleteTransactionById(model.id!);
      print(result);
      return Right(result);
    } catch (e) {
      print(e);
      return const Left(GeneralFailure('Unable to delete transaction'));
    }
  }

  @override
  Future<Either<Failure, CurrentMonthFinancialModel>>
      getCurrentMonthFinancials() async {
    try {
      final raw = await dbHelper.getCurrentMonthFinancials();
      String totalExpenses =
          (raw.map((raw) => raw['total_expenses']).toList()[0] ?? '--').toString() ;
      String totalIncome =
          (raw.map((raw) => raw['total_income']).toList()[0] ?? '--').toString();
      String netBalance;
      if (totalExpenses == '--' && totalIncome == '--'){
        netBalance = '--';
      }else {
      netBalance = ((double.tryParse(totalIncome) ?? 0) -
              (double.tryParse(totalExpenses) ?? 0))
          .toString();
      }

      final model = CurrentMonthFinancialModel(
        totalExpenses: totalExpenses,
        totalIncome: totalIncome,
        netBalance: netBalance,
        currentMonth: Utils.getCurrentMonth(showYear: true)
      );

      print(model);
      return Right(model);
    } catch (e) {
      print(e);
      return const Left(GeneralFailure('Unable to load transactions'));
    }
  }
}
