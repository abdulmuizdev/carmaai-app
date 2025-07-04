import 'package:carma/features/google_sign_in/domain/entities/signed_in_user_entity.dart';

abstract class GoogleSignInState {
  const GoogleSignInState();
}

class Initial extends GoogleSignInState {
  const Initial();
}

class SigningIn extends GoogleSignInState{
  const SigningIn();
}

class SignInError extends GoogleSignInState {
  final String message;
  const SignInError(this.message);
}

class SignedIn extends GoogleSignInState {
  const SignedIn();
}

class SigningOut extends GoogleSignInState{
  const SigningOut();
}

class SignOutError extends GoogleSignInState {
  final String message;
  const SignOutError(this.message);
}

class SignedOut extends GoogleSignInState {
  const SignedOut();
}

class CheckingIsUserSignedIn extends GoogleSignInState {
  const CheckingIsUserSignedIn();
}

class CheckIsUserSignedInError extends GoogleSignInState {
  final String message;
  const CheckIsUserSignedInError(this.message);
}

class CheckedIsUserSignedIn extends GoogleSignInState {
  final SignedInUserEntity? result;
  const CheckedIsUserSignedIn(this.result);
}

class DeletingAccount extends GoogleSignInState {
  const DeletingAccount();
}

class DeleteAccountError extends GoogleSignInState {
  final String message;
  const DeleteAccountError(this.message);
}

class DeletedAccount extends GoogleSignInState {
  const DeletedAccount();
}

class RestoringBackup extends GoogleSignInState {
  const RestoringBackup();
}

class RestoreBackupError extends GoogleSignInState {
  final String message;
  const RestoreBackupError(this.message);
}

class RestoredBackup extends GoogleSignInState {
  const RestoredBackup();
}