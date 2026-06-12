part of 'user_settings_bloc.dart';

@Freezed()
sealed class UserSettingsEvent with _$UserSettingsEvent {
  const factory UserSettingsEvent.settingsCommitted(
    UserSettingsState settings,
  ) = SettingsCommitted;
}
