import 'package:carma/features/settings/domain/entities/settings_entity.dart';

class SettingsModel extends SettingsEntity {

  final bool soundSettings;
  final String lastBackup;

  SettingsModel({required this.soundSettings, required this.lastBackup}) :
      super(soundSettings: soundSettings, lastBackup: lastBackup);
}