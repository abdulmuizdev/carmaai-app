import 'package:carma/core/errors/failure.dart';
import 'package:dartz/dartz.dart';
import '../repositories/backup_repository.dart';

class UploadBackupToIcloudUseCase {
  final BackupRepository backupRepository;

  UploadBackupToIcloudUseCase(this.backupRepository);

  Future<Either<Failure, void>> execute(){
    return backupRepository.uploadBackupToiCloud();
  }
}