import 'package:carma/core/errors/failure.dart';
import 'package:carma/features/charts/data/data_sources/lifetime_financials_data_source.dart';
import 'package:carma/features/charts/data/models/lifetime_financials_model.dart';
import 'package:carma/features/charts/domain/entities/lifetime_financials_entity.dart';
import 'package:carma/features/charts/domain/repositories/lifetime_financials_repository.dart';
import 'package:dartz/dartz.dart';

class LifetimeFinancialsRepositoryImpl extends LifetimeFinancialsRepository {
  final LifeTimeFinancialsDataSource lifeTimeFinancialsDataSource;

  LifetimeFinancialsRepositoryImpl(this.lifeTimeFinancialsDataSource);

  @override
  Future<Either<Failure, List<LifetimeFinancialsModel>>> getLifetimeFinancials() {
    return lifeTimeFinancialsDataSource.getLifeTimeFinancials();
  }

}