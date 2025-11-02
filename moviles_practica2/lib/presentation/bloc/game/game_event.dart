import 'package:equatable/equatable.dart';
import '../../../data/providers/word_provider.dart';

abstract class GameEvent extends Equatable {
  const GameEvent();

  @override
  List<Object> get props => [];
}

class StartNewGame extends GameEvent {
  final Difficulty difficulty;

  const StartNewGame({required this.difficulty});

  @override
  List<Object> get props => [difficulty];
}

class LetterKeyPressed extends GameEvent {
  final String letter;

  const LetterKeyPressed({required this.letter});

  @override
  List<Object> get props => [letter];
}

class DeleteKeyPressed extends GameEvent {}

class SubmitWord extends GameEvent {}