import 'package:carma/core/errors/failure.dart';
import 'package:carma/features/settings/domain/repositories/settings_repository.dart';
import 'package:dartz/dartz.dart';

class ChangeSoundEffectSettingsUseCase {
  final SettingsRepository settingsRepository;

  ChangeSoundEffectSettingsUseCase(this.settingsRepository);


  Future<Either<Failure, bool>> execute(bool state){
    return settingsRepository.setSoundEffectsEnabled(state);
  }

}