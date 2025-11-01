import 'package:equatable/equatable.dart';
import '../../../data/providers/word_provider.dart'; // Importamos nuestro enum Difficulty

// Clase base abstracta de la que todos los eventos heredarán.
// Extiende Equatable para poder comparar eventos si fuera necesario.
abstract class GameEvent extends Equatable {
  const GameEvent();

  @override
  List<Object> get props => [];
}

// Evento para iniciar una nueva partida.
// Lleva consigo la dificultad elegida.
class StartNewGame extends GameEvent {
  final Difficulty difficulty;

  const StartNewGame({required this.difficulty});

  @override
  List<Object> get props => [difficulty];
}

// Evento para cuando el usuario pulsa una tecla de letra.
class LetterKeyPressed extends GameEvent {
  final String letter;

  const LetterKeyPressed({required this.letter});

  @override
  List<Object> get props => [letter];
}

// Evento para cuando el usuario pulsa la tecla de borrar.
class DeleteKeyPressed extends GameEvent {}

// Evento para cuando el usuario pulsa la tecla de enviar para comprobar la palabra.
class SubmitWord extends GameEvent {}