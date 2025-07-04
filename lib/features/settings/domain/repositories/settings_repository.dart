import 'package:carma/core/errors/failure.dart';
import 'package:carma/features/settings/domain/entities/settings_entity.dart';
import 'package:dartz/dartz.dart';

abstract class SettingsRepository {
  Future<Either<Failure, bool>> setSoundEffectsEnabled(bool state);
  Future<Either<Failure, SettingsEntity>> getSoundEffectsSetting();
  Future<Either<Failure, void>> deleteAllData();
}