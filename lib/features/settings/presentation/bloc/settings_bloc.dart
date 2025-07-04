import 'package:carma/features/settings/domain/use_cases/change_sound_effect_settings_use_case.dart';
import 'package:carma/features/settings/domain/use_cases/delete_all_data_use_case.dart';
import 'package:carma/features/settings/domain/use_cases/get_sound_effect_setting_use_case.dart';
import 'package:carma/features/settings/presentation/bloc/settings_event.dart';
import 'package:carma/features/settings/presentation/bloc/settings_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final ChangeSoundEffectSettingsUseCase _changeSoundEffectSettingsUseCase;
  final GetSoundEffectSettingUseCase _getSoundEffectSettingUseCase;
  final DeleteAllDataUseCase _deleteAllDataUseCase;

  SettingsBloc(this._changeSoundEffectSettingsUseCase,
      this._getSoundEffectSettingUseCase, this._deleteAllDataUseCase)
      : super(const Initial()) {
    on<ChangeSoundEffectSetting>((event, emit) async {
      final result = await _changeSoundEffectSettingsUseCase.execute(
          event.state);
      result.fold((left) {
        emit(GetSettingsError(left.message));
      }, (right) {
        emit(ChangedSoundEffectSetting(right));
      });
    });

    on<GetSavedSettings>((event, emit) async {
      final result = await _getSoundEffectSettingUseCase.execute();
      result.fold((left) {
        emit(GetSettingsError(left.message));
      }, (right) {
        emit(GotSettings(right.soundSettings, right.lastBackup));
      });
    });

    on<DeleteAllData>((event, emit) async {
      final result = await _deleteAllDataUseCase.execute();
      result.fold((left){
        emit(DeleteAllDataError(left.message));
      }, (right){
        emit(const DeletedAllData());
      });
    });
  }

}