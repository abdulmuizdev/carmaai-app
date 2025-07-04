import 'package:carma/core/errors/failure.dart';
import 'package:dartz/dartz.dart';
import '../repositories/backup_repository.dart';

class UploadBackupToGoogleDriveUseCase {
  final BackupRepository googleDriveBackupRepository;

  UploadBackupToGoogleDriveUseCase(this.googleDriveBackupRepository);

  Future<Either<Failure, void>> execute(){
    return googleDriveBackupRepository.uploadBackupToGoogleDrive();
  }
}