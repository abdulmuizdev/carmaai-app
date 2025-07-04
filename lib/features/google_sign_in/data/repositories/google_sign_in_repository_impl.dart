import 'package:carma/core/errors/failure.dart';
import 'package:carma/features/google_sign_in/data/data_sources/google_sign_in_data_source.dart';
import 'package:carma/features/google_sign_in/data/models/signed_in_user_model.dart';
import 'package:carma/features/google_sign_in/domain/repositories/google_sign_in_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInRepositoryImpl extends GoogleSignInRepository {
  final GoogleSignInDataSource googleSignInDataSource;

  GoogleSignInRepositoryImpl(this.googleSignInDataSource);

  @override
  Future<Either<Failure, GoogleSignInAccount>> signIn() {
    return googleSignInDataSource.signIn();
  }

  @override
  Future<Either<Failure, void>> signOut() {
    return googleSignInDataSource.signOut();
  }

  @override
  Future<Either<Failure, SignedInUserModel?>> isUserSignedIn() {
    return googleSignInDataSource.isUserSignedIn();
  }

}