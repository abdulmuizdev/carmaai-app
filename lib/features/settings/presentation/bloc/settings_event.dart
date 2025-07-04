abstract class SettingsEvent {
  const SettingsEvent();
}

class ChangeSoundEffectSetting extends SettingsEvent {
  final bool state;
  ChangeSoundEffectSetting(this.state);
}

class GetSavedSettings extends SettingsEvent {
  const GetSavedSettings();
}

class DeleteAllData extends SettingsEvent {
  const DeleteAllData();
}