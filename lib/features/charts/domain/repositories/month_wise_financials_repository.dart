import 'package:carma/core/errors/failure.dart';
import 'package:carma/features/charts/domain/entities/month_wise_financial_entity.dart';
import 'package:dartz/dartz.dart';

abstract class MonthWiseFinancialsRepository {
  Future<Either<Failure, List<MonthWiseFinancialEntity>>> getMonthWiseFinancials();
}