import 'package:carma/core/errors/failure.dart';
import 'package:carma/features/splash/data/data_sources/initialization_data_source.dart';
import 'package:carma/features/splash/domain/repositories/initialize_repository.dart';
import 'package:dartz/dartz.dart';

class InitializeRepositoryImpl extends InitializeRepository {
  InitializationDataSource initializationDataSource;

  InitializeRepositoryImpl(this.initializationDataSource);

  @override
  Future<Either<Failure, void>> initializeCategories() {
    return initializationDataSource.initializeCategories();
  }

}