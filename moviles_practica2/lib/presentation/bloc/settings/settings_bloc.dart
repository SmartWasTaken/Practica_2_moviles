import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/preferences_repository.dart';
import 'settings_event.dart';
import 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final PreferencesRepository _repository;

  SettingsBloc() : _repository = PreferencesRepository(), super(SettingsState.initial()) {
    on<LoadSettings>((event, emit) async {
      final highContrast = await _repository.getHighContrast();
      final haptics = await _repository.getHaptics();
      emit(state.copyWith(isHighContrast: highContrast, isHapticsEnabled: haptics));
    });

    on<ToggleHighContrast>((event, emit) async {
      await _repository.saveHighContrast(event.isEnabled);
      emit(state.copyWith(isHighContrast: event.isEnabled));
    });

    on<ToggleHaptics>((event, emit) async {
      await _repository.saveHaptics(event.isEnabled);
      emit(state.copyWith(isHapticsEnabled: event.isEnabled));
    });
  }
}