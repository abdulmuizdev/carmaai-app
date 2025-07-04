import 'package:carma/core/errors/failure.dart';
import 'package:carma/features/charts/domain/entities/month_wise_financial_entity.dart';
import 'package:carma/features/charts/domain/repositories/month_wise_financials_repository.dart';
import 'package:dartz/dartz.dart';

class GetMonthWiseFinancialsUseCase {
  final MonthWiseFinancialsRepository monthWiseFinancialsRepository;

  GetMonthWiseFinancialsUseCase(this.monthWiseFinancialsRepository);

  Future<Either<Failure, List<MonthWiseFinancialEntity>>> execute() {
    return monthWiseFinancialsRepository.getMonthWiseFinancials();
  }
}
