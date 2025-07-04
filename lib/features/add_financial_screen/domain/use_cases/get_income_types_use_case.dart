import 'package:carma/core/errors/failure.dart';
import 'package:carma/features/add_financial_screen/domain/entities/financial_type_entity.dart';
import 'package:carma/features/add_financial_screen/domain/repositories/financial_type_repository.dart';
import 'package:dartz/dartz.dart';

class GetIncomeTypesUseCase {
  FinancialTypeRepository financialTypeRepository;
  GetIncomeTypesUseCase(this.financialTypeRepository);

  Future<Either<Failure, List<FinancialTypeEntity>>> execute(){
    return financialTypeRepository.getIncomeTypes();
  }
}