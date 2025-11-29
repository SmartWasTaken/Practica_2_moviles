import 'package:equatable/equatable.dart';

abstract class SettingsEvent extends Equatable {
  const SettingsEvent();
  @override
  List<Object> get props => [];
}

class LoadSettings extends SettingsEvent {}

class ToggleHighContrast extends SettingsEvent {
  final bool isEnabled;
  const ToggleHighContrast(this.isEnabled);
  @override
  List<Object> get props => [isEnabled];
}

class ToggleHaptics extends SettingsEvent {
  final bool isEnabled;
  const ToggleHaptics(this.isEnabled);
  @override
  List<Object> get props => [isEnabled];
}