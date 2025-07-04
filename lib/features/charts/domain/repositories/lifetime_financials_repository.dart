import 'package:carma/core/errors/failure.dart';
import 'package:carma/features/charts/domain/entities/lifetime_financials_entity.dart';
import 'package:dartz/dartz.dart';

abstract class LifetimeFinancialsRepository {
  Future<Either<Failure, List<LifetimeFinancialsEntity>>> getLifetimeFinancials();
}