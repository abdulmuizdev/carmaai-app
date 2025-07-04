import 'package:carma/core/errors/failure.dart';
import 'package:dartz/dartz.dart';

import '../../../features/backup/domain/repositories/backup_repository.dart';

class RestoreBackupFromIcloudUseCase {
  final BackupRepository backupRepository;

  RestoreBackupFromIcloudUseCase(this.backupRepository);

  Future<Either<Failure, void>> execute(){
    return backupRepository.restoreBackupFromiCloud();
  }
}