import 'package:carma/core/errors/failure.dart';
import 'package:carma/features/google_sign_in/data/models/signed_in_user_model.dart';
import 'package:dartz/dartz.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

abstract class GoogleSignInDataSource {
  Future<Either<Failure, GoogleSignInAccount>> signIn();

  Future<Either<Failure, SignedInUserModel?>> isUserSignedIn();

  Future<Either<Failure, void>> signOut();
}

class GoogleSignInDataSourceImpl extends GoogleSignInDataSource {
  final GoogleSignIn _googleSignIn;
  final FlutterSecureStorage _secureStorage;

  GoogleSignInDataSourceImpl(this._googleSignIn, this._secureStorage);

  @override
  Future<Either<Failure, GoogleSignInAccount>> signIn() async {
    try {
      // Try signing in silently first, to check for existing session
      GoogleSignInAccount? account = await _googleSignIn.signInSilently();

      if (account != null) {
        print('account is this after sign in: $account');
        return Right(account); // Already signed in silently
      } else {
        // If no active session, proceed with the sign-in process
        account = await _googleSignIn.signIn();
        print('account is this after sign in: $account');
        if (account == null) {
          return const Left(GeneralFailure('Unable to sign in'));
        }

        // Store account details securely
        await _secureStorage.write(key: 'userName', value: account.displayName);
        await _secureStorage.write(key: 'userEmail', value: account.email);
        await _secureStorage.write(key: 'userId', value: account.id);

        return Right(account);
      }
    } catch (e) {
      print(e);
      return const Left(GeneralFailure('Unable to sign in'));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      // Sign out from Google Sign-In
      await _googleSignIn.signOut();
      await _secureStorage.delete(key: 'userName');
      await _secureStorage.delete(key: 'userEmail');
      await _secureStorage.delete(key: 'userId');

      return const Right(unit);
    } catch (e) {
      print(e);
      return const Left(GeneralFailure('Unable to sign out'));
    }
  }

  // @override
  // Future<Either<Failure, SignedInUserModel?>> isUserSignedIn() async {
  //   try {
  //     GoogleSignInAccount? account = await _googleSignIn.signInSilently();
  //
  //     if (account == null) {
  //       return const Right(null);
  //     } else {
  //
  //       final userName = await _secureStorage.read(key: 'userName');
  //       final userEmail = await _secureStorage.read(key: 'userEmail');
  //       final userId = await _secureStorage.read(key: 'userId');
  //
  //       if (userName == null) {
  //         await _secureStorage.write(key: 'userName', value: account.displayName);
  //       }
  //
  //       if (userEmail == null) {
  //         await _secureStorage.write(key: 'userEmail', value: account.email);
  //       }
  //
  //       if (userId == null) {
  //         await _secureStorage.write(key: 'userId', value: account.id);
  //       }
  //
  //
  //       return Right(SignedInUserModel(id: userId!, name: userName, email: userEmail!));
  //     }
  //
  //
  //   }catch(e) {
  //     print(e);
  //     return const Left(GeneralFailure('Unable to check if the user is signed in or not'));
  //   }
  // }

  @override
  Future<Either<Failure, SignedInUserModel?>> isUserSignedIn() async {
    try {
      final userName = await _secureStorage.read(key: 'userName');
      final userEmail = await _secureStorage.read(key: 'userEmail');
      final userId = await _secureStorage.read(key: 'userId');

      if (userName == null) {
        return const Right(null);
      }

      if (userEmail == null) {
        return const Right(null);
      }

      if (userId == null) {
        return const Right(null);
      }

      return Right(
          SignedInUserModel(id: userId, name: userName, email: userEmail));
    } catch (e) {
      print(e);
      return const Left(
          GeneralFailure('Unable to check if the user is signed in or not'));
    }
  }
}
