import 'package:carma/core/errors/failure.dart';
import 'package:dartz/dartz.dart';

abstract class BackupRepository {
  Future<Either<Failure, void>> uploadBackupToGoogleDrive();
  Future<Either<Failure, void>> deleteBackupFromGoogleDrive();
  Future<Either<Failure, void>> restoreBackupFromGoogleDrive();

  Future<Either<Failure, void>> uploadBackupToiCloud();
  Future<Either<Failure, void>> deleteBackupFromiCloud();
  Future<Either<Failure, void>> restoreBackupFromiCloud();
}