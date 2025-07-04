import 'package:carma/core/errors/failure.dart';
import 'package:carma/features/add_financial_screen/data/data_sources/financial_type_data_source.dart';
import 'package:carma/features/add_financial_screen/domain/entities/financial_type_entity.dart';
import 'package:carma/features/add_financial_screen/domain/repositories/financial_type_repository.dart';
import 'package:dartz/dartz.dart';

class FinancialTypeRepositoryImpl extends FinancialTypeRepository {
  FinancialTypeDataSource financialTypeDataSource;

  FinancialTypeRepositoryImpl(this.financialTypeDataSource);

  @override
  Future<Either<Failure, List<FinancialTypeEntity>>> getExpenseTypes() {
    return financialTypeDataSource.getExpenseTypes();
  }

  @override
  Future<Either<Failure, List<FinancialTypeEntity>>> getIncomeTypes() {
    return financialTypeDataSource.getIncomeTypes();
  }

}