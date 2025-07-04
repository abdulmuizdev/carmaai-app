import 'package:carma/core/db/db_helper.dart';
import 'package:carma/core/errors/failure.dart';
import 'package:carma/core/utils/Utils.dart';
import 'package:carma/features/charts/data/models/month_wise_financials_model.dart';
import 'package:carma/features/charts/domain/entities/month_wise_financial_entity.dart';
import 'package:dartz/dartz.dart';

abstract class MonthWiseFinancialsDataSource {
  Future<Either<Failure, List<MonthWiseFinancialModel>>>
      getMonthWiseFinancials();
}

class MonthWiseFinancialsDataSourceImpl extends MonthWiseFinancialsDataSource {
  final DbHelper dbHelper;

  MonthWiseFinancialsDataSourceImpl(this.dbHelper);

  @override
  Future<Either<Failure, List<MonthWiseFinancialModel>>>
      getMonthWiseFinancials() async {
    try {
      final rawData = await dbHelper.getMonthlyFinancials();

      final List<MonthWiseFinancialModel> monthWiseFinancials = [];
      for (var raw in rawData) {
        monthWiseFinancials.add(MonthWiseFinancialModel(
            year: ((raw['year'] ?? '-').toString()) ?? '--',
            month: ((raw['month'] ?? '-').toString()) ?? '--',
            totalExpenses:
                Utils.formatNumber((raw['total_expenses'] ?? '-').toString()) ??
                    '--',
            totalIncome:
                Utils.formatNumber((raw['total_income'] ?? '-').toString()) ??
                    '--',
            balance: Utils.formatNumber(
                    _getBalance(raw['total_income'], raw['total_expenses'])) ??
                '--'));
      }
      return Right(monthWiseFinancials);
    } catch (e) {
      print('error is here');
      print(e);
      return const Left(GeneralFailure('Unable to load chart'));
    }
  }

  String _getBalance(income, expenses) {
    if (income == null && expenses == null) {
      return '-';
    }
    return ((double.tryParse((income ?? 0).toString()) ?? 0) -
            (double.tryParse((expenses ?? 0).toString()) ?? 0))
        .toString();
  }
}
