import 'package:carma/core/errors/failure.dart';
import 'package:carma/features/settings/domain/repositories/settings_repository.dart';
import 'package:dartz/dartz.dart';

class DeleteAllDataUseCase {
  final SettingsRepository settingsRepository;

  const DeleteAllDataUseCase(this.settingsRepository);

  Future<Either<Failure, void>> execute(){
    return settingsRepository.deleteAllData();
  }
}