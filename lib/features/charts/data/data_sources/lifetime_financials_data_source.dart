import 'package:carma/core/db/db_helper.dart';
import 'package:carma/core/errors/failure.dart';
import 'package:carma/core/utils/Utils.dart';
import 'package:carma/features/charts/data/models/lifetime_financials_model.dart';
import 'package:carma/features/charts/data/models/month_wise_financials_model.dart';
import 'package:carma/features/charts/domain/entities/month_wise_financial_entity.dart';
import 'package:dartz/dartz.dart';

abstract class LifeTimeFinancialsDataSource {
  Future<Either<Failure, List<LifetimeFinancialsModel>>> getLifeTimeFinancials();
}

class LifeTimeFinancialsDataSourceImpl extends LifeTimeFinancialsDataSource {
  final DbHelper dbHelper;

  LifeTimeFinancialsDataSourceImpl(this.dbHelper);

  @override
  Future<Either<Failure, List<LifetimeFinancialsModel>>> getLifeTimeFinancials() async {
    try {
      final rawData = await dbHelper.getLifetimeFinancials();

      final List<LifetimeFinancialsModel> list = [];
      for (var raw in rawData) {
        list.add(
          LifetimeFinancialsModel(
            lifeTimeExpenses: Utils.formatNumber((raw['total_expenses']).toString() ?? '--') ?? '--',
            lifeTimeIncome: Utils.formatNumber((raw['total_income']).toString() ?? '-') ?? '--',
            lifeTimeBalance: Utils.formatNumber(_getBalance((raw['total_income']).toString(), (raw['total_expenses']).toString())) ?? '--',
          ),
        );
      }
      return Right(list);
    } catch (e) {
      print('error is here');
      print(e);
      return const Left(GeneralFailure('Unable to load chart'));
    }
  }

  String _getBalance(income, expenses) {
    if (income == null && expenses == null) {
      return '--';
    }
    return ((double.tryParse((income ?? 0).toString()) ?? 0) - (double.tryParse((expenses ?? 0).toString()) ?? 0))
        .toString();
  }
}
