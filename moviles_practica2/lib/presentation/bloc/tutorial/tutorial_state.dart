import 'package:equatable/equatable.dart';
import '../../../core/constants/enums.dart';

enum TutorialStage {
  initial,
  step1_Welcome,
  step2_GuessHOLA,
  step3_ExplainColors,
  step3b_ExplainHints,
  step4_ChooseDifficulty,
  step5_GuessJUGAR,
  step6_GuessJARDIN,
  step7_FinalCongrats,
}

class TutorialState extends Equatable {
  final TutorialStage stage;
  final String correctWord;
  final List<List<String>> guesses;
  final List<List<LetterStatus>> statuses;
  final int currentAttempt;
  final int maxAttempts;
  final String instructionTitle;
  final String instructionText;
  final bool keyboardEnabled;

  const TutorialState({
    required this.stage,
    required this.correctWord,
    required this.guesses,
    required this.statuses,
    required this.currentAttempt,
    required this.maxAttempts,
    required this.instructionTitle,
    required this.instructionText,
    required this.keyboardEnabled,
  });

  factory TutorialState.initial() {
    return const TutorialState(
      stage: TutorialStage.initial,
      correctWord: 'HOLA',
      guesses: [],
      statuses: [],
      currentAttempt: 0,
      maxAttempts: 6,
      instructionTitle: '',
      instructionText: '',
      keyboardEnabled: false,
    );
  }

  TutorialState copyWith({
    TutorialStage? stage,
    String? correctWord,
    List<List<String>>? guesses,
    List<List<LetterStatus>>? statuses,
    int? currentAttempt,
    int? maxAttempts,
    String? instructionTitle,
    String? instructionText,
    bool? keyboardEnabled,
  }) {
    return TutorialState(
      stage: stage ?? this.stage,
      correctWord: correctWord ?? this.correctWord,
      guesses: guesses ?? this.guesses,
      statuses: statuses ?? this.statuses,
      currentAttempt: currentAttempt ?? this.currentAttempt,
      maxAttempts: maxAttempts ?? this.maxAttempts,
      instructionTitle: instructionTitle ?? this.instructionTitle,
      instructionText: instructionText ?? this.instructionText,
      keyboardEnabled: keyboardEnabled ?? this.keyboardEnabled,
    );
  }

  @override
  List<Object?> get props => [
    stage,
    correctWord,
    guesses,
    statuses,
    currentAttempt,
    maxAttempts,
    instructionTitle,
    instructionText,
    keyboardEnabled,
  ];
}