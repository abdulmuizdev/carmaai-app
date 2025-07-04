import 'package:carma/core/errors/failure.dart';
import 'package:carma/features/splash/domain/repositories/initialize_repository.dart';
import 'package:dartz/dartz.dart';

class InitializeCategoriesUseCase {
  InitializeRepository initializeRepository;

  InitializeCategoriesUseCase(this.initializeRepository);


  Future<Either<Failure, void>> execute() {
    return initializeRepository.initializeCategories();
  }
}