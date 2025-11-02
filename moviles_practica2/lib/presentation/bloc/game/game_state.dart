import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import '../../../data/providers/word_provider.dart';

enum GameStatus { playing, win, lose, initial }

enum LetterStatus { initial, notInWord, inWord, correctPosition }

class GameState extends Equatable {
  // 1. DATOS DEL JUEGO
  final GameStatus gameStatus;
  final String correctWord;
  final int wordSize;
  final List<List<String>> guesses;
  final List<List<LetterStatus>> statuses;
  final int currentAttempt;
  final Difficulty difficulty;
  final DateTime? startTime;

  const GameState({
    required this.gameStatus,
    required this.correctWord,
    required this.wordSize,
    required this.guesses,
    required this.statuses,
    required this.currentAttempt,
    required this.difficulty,
    this.startTime,
  });

  factory GameState.initial() {
    return const GameState(
      gameStatus: GameStatus.initial,
      correctWord: '',
      wordSize: 5,
      guesses: [],
      statuses: [],
      currentAttempt: 0,
      difficulty: Difficulty.medio,
      startTime: null,
    );
  }

  GameState copyWith({
    GameStatus? gameStatus,
    String? correctWord,
    int? wordSize,
    List<List<String>>? guesses,
    List<List<LetterStatus>>? statuses,
    int? currentAttempt,
    Difficulty? difficulty,
    DateTime? startTime,
  }) {
    return GameState(
      gameStatus: gameStatus ?? this.gameStatus,
      correctWord: correctWord ?? this.correctWord,
      wordSize: wordSize ?? this.wordSize,
      guesses: guesses ?? this.guesses,
      statuses: statuses ?? this.statuses,
      currentAttempt: currentAttempt ?? this.currentAttempt,
      difficulty: difficulty ?? this.difficulty,
      startTime:  startTime ?? this.startTime,
    );
  }

  // 4. PROPIEDADES PARA EQUATABLE
  // Equatable necesita saber qué propiedades debe comparar para determinar
  // si dos instancias de GameState son iguales. Esto evita que la UI se
  // redibuje innecesariamente.
  @override
  List<Object?> get props => [
    gameStatus,
    correctWord,
    wordSize,
    guesses,
    statuses,
    currentAttempt,
    difficulty,
    startTime,
  ];
}