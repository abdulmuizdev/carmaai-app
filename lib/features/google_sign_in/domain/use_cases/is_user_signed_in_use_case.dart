import 'package:carma/core/errors/failure.dart';
import 'package:carma/features/google_sign_in/domain/entities/signed_in_user_entity.dart';
import 'package:carma/features/google_sign_in/domain/repositories/google_sign_in_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:google_sign_in/google_sign_in.dart';

class IsUserSignedInUseCase {
  final GoogleSignInRepository googleSignInRepository;

  IsUserSignedInUseCase(this.googleSignInRepository);

  Future<Either<Failure, SignedInUserEntity?>> execute(){
    return googleSignInRepository.isUserSignedIn();
  }
}