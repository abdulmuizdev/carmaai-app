import 'package:carma/core/errors/failure.dart';
import 'package:dartz/dartz.dart';

abstract class InitializeRepository {
  Future<Either<Failure, void>> initializeCategories();
}