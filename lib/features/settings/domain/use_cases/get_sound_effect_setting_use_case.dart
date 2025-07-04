import 'package:carma/core/errors/failure.dart';
import 'package:carma/features/settings/domain/entities/settings_entity.dart';
import 'package:carma/features/settings/domain/repositories/settings_repository.dart';
import 'package:dartz/dartz.dart';

class GetSoundEffectSettingUseCase {
  final SettingsRepository settingsRepository;

  GetSoundEffectSettingUseCase(this.settingsRepository);


  Future<Either<Failure, SettingsEntity>> execute(){
    return settingsRepository.getSoundEffectsSetting();
  }

}