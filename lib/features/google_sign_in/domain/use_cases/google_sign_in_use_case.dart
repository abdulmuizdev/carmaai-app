import 'package:carma/core/errors/failure.dart';
import 'package:carma/features/google_sign_in/domain/repositories/google_sign_in_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInUseCase {
  final GoogleSignInRepository googleSignInRepository;

  GoogleSignInUseCase(this.googleSignInRepository);

  Future<Either<Failure, GoogleSignInAccount>> execute(){
    return googleSignInRepository.signIn();
  }
}