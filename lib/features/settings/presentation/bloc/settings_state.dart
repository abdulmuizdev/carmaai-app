abstract class SettingsState {
  const SettingsState();
}

class Initial extends SettingsState {
  const Initial();
}

class ChangingSoundEffectSetting extends SettingsState {
  const ChangingSoundEffectSetting();
}

class ChangedSoundEffectSetting extends SettingsState {
  final bool changedState;
  const ChangedSoundEffectSetting(this.changedState);
}

class GetSettingsError extends SettingsState {
  final String message;
  const GetSettingsError(this.message);
}

class GotSettings extends SettingsState {
  final bool soundSetting;
  final String lastBackup;
  GotSettings(this.soundSetting, this.lastBackup);
}

class DeletingAllData extends SettingsState {
  const DeletingAllData();
}

class DeleteAllDataError extends SettingsState {
  final String message;
  const DeleteAllDataError(this.message);
}

class DeletedAllData extends SettingsState {
  const DeletedAllData();
}

