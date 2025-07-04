abstract class GoogleSignInEvent {
  const GoogleSignInEvent();
}

class SignIn extends GoogleSignInEvent {
  bool isApple;
  SignIn({this.isApple = false});
}

class SignOut extends GoogleSignInEvent {
  const SignOut();
}

class CheckIsUserSignedIn extends GoogleSignInEvent {
  const CheckIsUserSignedIn();
}

class DeleteAccount extends GoogleSignInEvent {
  const DeleteAccount();
}

class RestoreBackup extends GoogleSignInEvent {
  const RestoreBackup();
}