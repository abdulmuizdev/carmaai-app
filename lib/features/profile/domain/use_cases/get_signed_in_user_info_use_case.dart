import 'package:carma/core/errors/failure.dart';
import 'package:carma/features/profile/domain/entities/profile_entity.dart';
import 'package:carma/features/profile/domain/repositories/profile_repository.dart';
import 'package:dartz/dartz.dart';

class GetSignedInUserInfoUseCase {
  final ProfileRepository profileRepository;

  GetSignedInUserInfoUseCase(this.profileRepository);

  Future<Either<Failure, ProfileEntity>> execute(){
    return profileRepository.getSignedInUserInfo();
  }
}