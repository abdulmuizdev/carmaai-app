import 'package:carma/features/profile/domain/entities/profile_entity.dart';

abstract class ProfileState {
  const ProfileState();
}

class Initial extends ProfileState {
  const Initial();
}

class GettingSignedInUserInfo extends ProfileState {
  const GettingSignedInUserInfo();
}

class SignedInUserInfoError extends ProfileState {
  final String message;
  const SignedInUserInfoError(this.message);
}

class GotSignedInUserInfo extends ProfileState {
  final ProfileEntity result;
  const GotSignedInUserInfo(this.result);
}