import 'package:carma/core/errors/failure.dart';
import 'package:carma/features/google_sign_in/domain/entities/signed_in_user_entity.dart';
import 'package:dartz/dartz.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract class GoogleSignInRepository {
  Future<Either<Failure, GoogleSignInAccount>> signIn();
  Future<Either<Failure, void>> signOut();
  Future<Either<Failure, SignedInUserEntity?>> isUserSignedIn();
}