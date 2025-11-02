import 'package:equatable/equatable.dart';
import '../../../core/constants/enums.dart';

abstract class GameEvent extends Equatable {
  const GameEvent();
  @override
  List<Object?> get props => [];
}

// MODIFICADO: Ahora lleva el modo de juego y un límite de tiempo opcional
class StartNewGame extends GameEvent {
  final Difficulty difficulty;
  final GameMode gameMode;
  final Duration? timeLimit; // Opcional, solo para Contrarreloj

  const StartNewGame({
    required this.difficulty,
    required this.gameMode,
    this.timeLimit,
  });

  @override
  List<Object?> get props => [difficulty, gameMode, timeLimit];
}

// NUEVO: Este evento se enviará cada segundo para actualizar el timer
class TimerTicked extends GameEvent {
  final Duration duration;
  const TimerTicked(this.duration);

  @override
  List<Object> get props => [duration];
}

class LetterKeyPressed extends GameEvent {
  final String letter;
  const LetterKeyPressed({required this.letter});
  @override
  List<Object> get props => [letter];
}

class DeleteKeyPressed extends GameEvent {}

class SubmitWord extends GameEvent {}