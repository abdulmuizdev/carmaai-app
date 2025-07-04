import 'package:carma/core/errors/failure.dart';
import 'package:dartz/dartz.dart';

import '../../../features/backup/domain/repositories/backup_repository.dart';

class RestoreBackupFromGoogleDriveUseCase {
  final BackupRepository googleDriveBackupRepository;

  RestoreBackupFromGoogleDriveUseCase(this.googleDriveBackupRepository);

  Future<Either<Failure, void>> execute(){
    return googleDriveBackupRepository.restoreBackupFromGoogleDrive();
  }
}