import 'package:carma/core/errors/failure.dart';
import 'package:carma/features/profile/data/models/profile_model.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract class ProfileDataSource {
  Future<Either<Failure, ProfileModel>> getSignedInUserInfo();
}

class ProfileDataSourceImpl extends ProfileDataSource {
  final GoogleSignIn _googleSignIn;
  final FlutterSecureStorage _secureStorage;
  ProfileDataSourceImpl(this._googleSignIn, this._secureStorage);

  @override
  Future<Either<Failure, ProfileModel>> getSignedInUserInfo() async {
    try {
      GoogleSignInAccount? signedInUser = _googleSignIn.currentUser;
      print('current user is this $signedInUser');

      signedInUser ??= await _googleSignIn.signInSilently();

      if (signedInUser == null) {

        final userName = await _secureStorage.read(key: 'userName');
        final userEmail = await _secureStorage.read(key: 'userEmail');
        final userId = await _secureStorage.read(key: 'userId');

        if (userName == null || userEmail == null || userId == null) {
          return Right(ProfileModel(id: 'Sign In, more exciting!', email: 'Sign In'));
        }else {
          return Right(ProfileModel(id: userId, email: userEmail, name: userName));
        }
      }
      return Right(ProfileModel(id: signedInUser.id, email: signedInUser.email, name: signedInUser.displayName));
    } catch (e) {
      print(e);
      final userName = await _secureStorage.read(key: 'userName');
      final userEmail = await _secureStorage.read(key: 'userEmail');
      final userId = await _secureStorage.read(key: 'userId');
      if (userName == null || userEmail == null || userId == null) {
        return Right(ProfileModel(id: 'Sign In, more exciting!', email: 'Sign In'));
      }else {
        return Right(ProfileModel(id: userId, email: userEmail, name: userName));
      }
    }
  }
}
