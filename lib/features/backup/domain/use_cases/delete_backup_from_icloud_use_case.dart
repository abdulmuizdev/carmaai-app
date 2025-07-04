import 'package:carma/core/errors/failure.dart';
import 'package:dartz/dartz.dart';

import '../repositories/backup_repository.dart';

class DeleteBackupFromIcloudUseCase {
  final BackupRepository backupRepository;

  DeleteBackupFromIcloudUseCase(this.backupRepository);

  Future<Either<Failure, void>> execute(){
    return backupRepository.deleteBackupFromiCloud();
  }
}