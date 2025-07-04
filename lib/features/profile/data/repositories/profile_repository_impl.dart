import 'package:carma/core/errors/failure.dart';
import 'package:carma/features/profile/data/data_sources/profile_data_source.dart';
import 'package:carma/features/profile/data/models/profile_model.dart';
import 'package:carma/features/profile/domain/repositories/profile_repository.dart';
import 'package:dartz/dartz.dart';

class ProfileRepositoryImpl extends ProfileRepository {
  final ProfileDataSource profileDataSource;

  ProfileRepositoryImpl(this.profileDataSource);

  @override
  Future<Either<Failure, ProfileModel>> getSignedInUserInfo() {
    return profileDataSource.getSignedInUserInfo();
  }

}