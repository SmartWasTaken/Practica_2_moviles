import 'package:equatable/equatable.dart';

class SettingsState extends Equatable {
  final bool isHighContrast;
  final bool isHapticsEnabled;

  const SettingsState({
    required this.isHighContrast,
    required this.isHapticsEnabled,
  });

  factory SettingsState.initial() {
    return const SettingsState(isHighContrast: false, isHapticsEnabled: true);
  }

  SettingsState copyWith({
    bool? isHighContrast,
    bool? isHapticsEnabled,
  }) {
    return SettingsState(
      isHighContrast: isHighContrast ?? this.isHighContrast,
      isHapticsEnabled: isHapticsEnabled ?? this.isHapticsEnabled,
    );
  }

  @override
  List<Object> get props => [isHighContrast, isHapticsEnabled];
}