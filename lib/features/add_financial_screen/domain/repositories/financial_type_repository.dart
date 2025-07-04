import 'package:carma/core/errors/failure.dart';
import 'package:carma/features/add_financial_screen/domain/entities/financial_type_entity.dart';
import 'package:dartz/dartz.dart';

abstract class FinancialTypeRepository {
  Future<Either<Failure, List<FinancialTypeEntity>>> getExpenseTypes();
  Future<Either<Failure, List<FinancialTypeEntity>>> getIncomeTypes();
}