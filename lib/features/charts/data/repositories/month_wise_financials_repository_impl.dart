import 'package:carma/core/errors/failure.dart';
import 'package:carma/features/charts/data/data_sources/month_wise_financials_data_source.dart';
import 'package:carma/features/charts/data/models/month_wise_financials_model.dart';
import 'package:carma/features/charts/domain/repositories/month_wise_financials_repository.dart';
import 'package:dartz/dartz.dart';

class MonthWiseFinancialsRepositoryImpl extends MonthWiseFinancialsRepository{
  final MonthWiseFinancialsDataSource monthWiseFinancialsDataSource;
  MonthWiseFinancialsRepositoryImpl(this.monthWiseFinancialsDataSource);
  @override
  Future<Either<Failure, List<MonthWiseFinancialModel>>> getMonthWiseFinancials() {
    return monthWiseFinancialsDataSource.getMonthWiseFinancials();
  }

}