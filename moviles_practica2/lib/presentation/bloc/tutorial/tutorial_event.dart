import 'package:equatable/equatable.dart';
import '../../../core/constants/enums.dart';

abstract class TutorialEvent extends Equatable {
  const TutorialEvent();
  @override
  List<Object?> get props => [];
}

class StartTutorial extends TutorialEvent {}

class TutorialLetterKeyPressed extends TutorialEvent {
  final String letter;
  const TutorialLetterKeyPressed({required this.letter});
  @override
  List<Object> get props => [letter];
}

class TutorialDeleteKeyPressed extends TutorialEvent {}

class TutorialSubmitWord extends TutorialEvent {}

class TutorialDifficultyChosen extends TutorialEvent {
  final Difficulty difficulty;
  const TutorialDifficultyChosen({required this.difficulty});
  @override
  List<Object> get props => [difficulty];
}

class TutorialNextStep extends TutorialEvent {}

class TutorialSkipped extends TutorialEvent {}