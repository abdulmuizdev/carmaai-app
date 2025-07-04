import 'package:carma/common/domain/use_cases/restore_backup_from_icloud_use_case.dart';
import 'package:carma/common/presentation/bloc/google_sign_in_event.dart';
import 'package:carma/common/presentation/bloc/google_sign_in_state.dart';
import 'package:carma/common/domain/use_cases/restore_backup_from_google_drive_use_case.dart';
import 'package:carma/features/google_sign_in/domain/use_cases/google_sign_in_use_case.dart';
import 'package:carma/features/google_sign_in/domain/use_cases/google_sign_out_use_case.dart';
import 'package:carma/features/google_sign_in/domain/use_cases/is_user_signed_in_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../../features/backup/domain/use_cases/delete_backup_from_google_drive_use_case.dart';

class GoogleSignInBloc extends Bloc<GoogleSignInEvent, GoogleSignInState> {
  final GoogleSignInUseCase _googleSignInUseCase;
  final GoogleSignOutUseCase _googleSignOutUseCase;
  final IsUserSignedInUseCase _isUserSignedInUseCase;
  final DeleteBackupFromGoogleDriveUseCase _deleteBackupFromGoogleDriveUseCase;
  final RestoreBackupFromGoogleDriveUseCase
      _restoreBackupFromGoogleDriveUseCase;
  final RestoreBackupFromIcloudUseCase _restoreBackupFromIcloudUseCase;

  GoogleSignInBloc(
    this._googleSignInUseCase,
    this._googleSignOutUseCase,
    this._isUserSignedInUseCase,
    this._deleteBackupFromGoogleDriveUseCase,
    this._restoreBackupFromGoogleDriveUseCase,
    this._restoreBackupFromIcloudUseCase,
  ) : super(const Initial()) {
    on<SignIn>((event, emit) async {
      emit(const SigningIn());

      if (event.isApple) {
        print('check 1');
        try {
          final credential = await SignInWithApple.getAppleIDCredential(
            scopes: [
              AppleIDAuthorizationScopes.email,
              AppleIDAuthorizationScopes.fullName,
            ],
          );
          print('check 2');
          print(credential);
          print(credential.userIdentifier);
          print(credential.email);
          print(credential.givenName);
          final _secureStorage = FlutterSecureStorage();
          print('check 3');
          await _secureStorage.write(
              key: 'userName', value: credential.givenName ?? ' ');
          await _secureStorage.write(
              key: 'userEmail', value: credential.email ?? 'Signed In');
          await _secureStorage.write(
              key: 'userId', value: credential.userIdentifier ?? ' ');
          print('check 4');
          emit(const SignedIn());
          print('check 5');
        } catch (e) {
          print(e);
          if (e is SignInWithAppleException) {
            emit(
              Initial(),
            );
            return;
          }
          if (e is SignInWithAppleNotSupportedException) {
            emit(
              SignInError('Not supported on your device'),
            );
            return;
          }
          emit(
            SignInError('Something went wrong'),
          );
        }
      } else {
        final result = await _googleSignInUseCase.execute();
        result.fold((left) {
          emit(SignInError(left.message));
        }, (right) {
          emit(const SignedIn());
        });
      }
    });

    on<SignOut>((event, emit) async {
      emit(const SigningOut());
      await _initiateSignOutProtocol(emit);
    });

    on<CheckIsUserSignedIn>((event, emit) async {
      final result = await _isUserSignedInUseCase.execute();
      result.fold((left) {
        emit(CheckIsUserSignedInError(left.message));
      }, (right) {
        emit(CheckedIsUserSignedIn(right));
      });
    });
// TODO: make sure all loading states are fired
    on<DeleteAccount>((event, emit) async {
      emit(const DeletingAccount());
      final result = await _deleteBackupFromGoogleDriveUseCase.execute();
      await result.fold((left) async {
        emit(DeleteAccountError(left.message));
        await _googleSignOutUseCase.execute();
        emit(const DeletedAccount());
      }, (right) async {
        await _googleSignOutUseCase.execute();
        emit(const DeletedAccount());
      });
    });

    on<RestoreBackup>((event, emit) async {
      emit(const RestoringBackup());
      final result = await _restoreBackupFromGoogleDriveUseCase.execute();
      await result.fold((left) async {
        print('Error restoring from drive: ${left.message}');

        final result = await _restoreBackupFromIcloudUseCase.execute();
        result.fold((left) {
          emit(const RestoreBackupError('Unable to restore backup'));
        }, (right) {
          emit(const RestoredBackup());
        });
      }, (right) {
        emit(const RestoredBackup());
      });
    });
  }

  Future<void> _initiateSignOutProtocol(emit) async {
    final result = await _googleSignOutUseCase.execute();
    result.fold((left) {
      emit(SignOutError(left.message));
    }, (right) {
      emit(const SignedOut());
    });
  }
}
