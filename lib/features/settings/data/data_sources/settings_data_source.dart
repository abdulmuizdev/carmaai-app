import 'package:carma/core/constants/constants.dart';
import 'package:carma/core/db/db_helper.dart';
import 'package:carma/core/errors/failure.dart';
import 'package:carma/features/settings/data/model/settings_model.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class SettingsDataSource {
  Future<Either<Failure, bool>> setSoundEffectsEnabled(bool state);

  Future<Either<Failure, SettingsModel>> getSoundEffectsSetting();

  Future<Either<Failure, void>> deleteAllData();
}

class SettingsDataSourceImpl extends SettingsDataSource {
  final FlutterSecureStorage flutterSecureStorage;
  final DbHelper dbHelper;

  SettingsDataSourceImpl(this.flutterSecureStorage, this.dbHelper);

  @override
  Future<Either<Failure, bool>> setSoundEffectsEnabled(bool state) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final success = await prefs.setBool(Constants.SOUND_EFFECTS_SP_KEY, state);
      if (success) {
        return Right(state);
      } else {
        return const Left(GeneralFailure('Failed to save sound effects setting.'));
      }
    } catch (e) {
      print(e);
      return const Left(GeneralFailure('An error occurred'));
    }
  }

  @override
  Future<Either<Failure, SettingsModel>> getSoundEffectsSetting() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isSoundSettingEnabled = prefs.getBool(Constants.SOUND_EFFECTS_SP_KEY) ?? true;

      final lastBackup = (await flutterSecureStorage.read(key: Constants.LAST_BACKUP) ?? '--');
      return Right(
        SettingsModel(soundSettings: isSoundSettingEnabled, lastBackup: lastBackup),
      );
    } catch (e) {
      print(e);
      return const Left(GeneralFailure('An error occurred'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteAllData() async {
    final result = await dbHelper.deleteAllData();
    if (!result) {
      return const Left(GeneralFailure('Unable to delete data'));
    }
    return const Right(unit);
  }
}
