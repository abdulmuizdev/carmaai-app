import 'package:carma/core/errors/failure.dart';
import 'package:dartz/dartz.dart';

import '../repositories/backup_repository.dart';

class DeleteBackupFromGoogleDriveUseCase {
  final BackupRepository googleDriveBackupRepository;

  DeleteBackupFromGoogleDriveUseCase(this.googleDriveBackupRepository);

  Future<Either<Failure, void>> execute(){
    return googleDriveBackupRepository.deleteBackupFromGoogleDrive();
  }
}