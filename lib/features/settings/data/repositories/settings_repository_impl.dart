import 'package:carma/core/errors/failure.dart';
import 'package:carma/features/settings/data/data_sources/settings_data_source.dart';
import 'package:carma/features/settings/data/model/settings_model.dart';
import 'package:carma/features/settings/domain/repositories/settings_repository.dart';
import 'package:dartz/dartz.dart';

class SettingsRepositoryImpl extends SettingsRepository {

  final SettingsDataSource settingsDataSource;

  SettingsRepositoryImpl(this.settingsDataSource);

  @override
  Future<Either<Failure, bool>> setSoundEffectsEnabled(bool state) {
    return settingsDataSource.setSoundEffectsEnabled(state);
  }

  @override
  Future<Either<Failure, SettingsModel>> getSoundEffectsSetting() {
    return settingsDataSource.getSoundEffectsSetting();
  }

  @override
  Future<Either<Failure, void>> deleteAllData() {
    return settingsDataSource.deleteAllData();
  }

}