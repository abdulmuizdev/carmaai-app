import 'package:carma/core/errors/failure.dart';
import 'package:carma/features/charts/domain/entities/lifetime_financials_entity.dart';
import 'package:carma/features/charts/domain/repositories/lifetime_financials_repository.dart';
import 'package:dartz/dartz.dart';

class GetLifetimeFinancialsUseCase {
  final LifetimeFinancialsRepository lifetimeFinancialsRepository;
  GetLifetimeFinancialsUseCase(this.lifetimeFinancialsRepository);

  Future<Either<Failure, List<LifetimeFinancialsEntity>>> execute(){
    return lifetimeFinancialsRepository.getLifetimeFinancials();
  }

}