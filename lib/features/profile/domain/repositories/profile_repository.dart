import 'package:carma/core/errors/failure.dart';
import 'package:carma/features/profile/domain/entities/profile_entity.dart';
import 'package:dartz/dartz.dart';

abstract class ProfileRepository {
  Future<Either<Failure, ProfileEntity>> getSignedInUserInfo();
}