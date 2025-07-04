import 'package:carma/core/errors/failure.dart';
import 'package:dartz/dartz.dart';

import '../../domain/repositories/backup_repository.dart';
import '../data_sources/backup_data_source.dart';

class BackupRepositoryImpl extends BackupRepository {
  final DriveBackupDataSource driveBackupDataSource;

  BackupRepositoryImpl(this.driveBackupDataSource);

  @override
  Future<Either<Failure, void>> uploadBackupToGoogleDrive() {
    return driveBackupDataSource.uploadBackupToGoogleDrive();
  }

  @override
  Future<Either<Failure, void>> deleteBackupFromGoogleDrive() {
    return driveBackupDataSource.deleteBackupFromGoogleDrive();
  }

  @override
  Future<Either<Failure, void>> restoreBackupFromGoogleDrive() {
    return driveBackupDataSource.restoreBackupFromGoogleDrive();
  }

  @override
  Future<Either<Failure, void>> deleteBackupFromiCloud() {
    return driveBackupDataSource.deleteBackupFromiCloud();
  }

  @override
  Future<Either<Failure, void>> restoreBackupFromiCloud() {
    return driveBackupDataSource.restoreBackupFromiCloud();
  }

  @override
  Future<Either<Failure, void>> uploadBackupToiCloud() {
    return driveBackupDataSource.uploadBackupToiCloud();
  }

}