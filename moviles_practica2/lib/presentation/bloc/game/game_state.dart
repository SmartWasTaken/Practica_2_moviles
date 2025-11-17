import 'package:equatable/equatable.dart';
import '../../../core/constants/enums.dart';
import '../../../core/models/emoji_puzzle.dart';

class GameState extends Equatable {
  final GameStatus gameStatus;
  final String correctWord;
  final int wordSize;
  final List<List<String>> guesses;
  final List<List<LetterStatus>> statuses;
  final int currentAttempt;
  final Difficulty difficulty;
  final DateTime? startTime;
  final GameMode gameMode;
  final Duration timerValue;
  final Duration? initialTimeLimit;
  final List<int> hintedIndices;
  final int hintsUsed;

  final EmojiPuzzle? currentPuzzle;
  final List<String> visibleEmojis;

  const GameState({
    required this.gameStatus,
    required this.correctWord,
    required this.wordSize,
    required this.guesses,
    required this.statuses,
    required this.currentAttempt,
    required this.difficulty,
    this.startTime,
    required this.gameMode,
    required this.timerValue,
    this.initialTimeLimit,
    required this.hintedIndices,
    required this.hintsUsed,
    this.currentPuzzle,
    required this.visibleEmojis,
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
      gameMode: GameMode.normal,
      timerValue: Duration.zero,
      initialTimeLimit: null,
      hintedIndices: [],
      hintsUsed: 0,
      currentPuzzle: null,
      visibleEmojis: [],
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
    GameMode? gameMode,
    Duration? timerValue,
    Duration? initialTimeLimit,
    List<int>? hintedIndices,
    int? hintsUsed,
    EmojiPuzzle? currentPuzzle,
    List<String>? visibleEmojis,
  }) {
    return GameState(
      gameStatus: gameStatus ?? this.gameStatus,
      correctWord: correctWord ?? this.correctWord,
      wordSize: wordSize ?? this.wordSize,
      guesses: guesses ?? this.guesses,
      statuses: statuses ?? this.statuses,
      currentAttempt: currentAttempt ?? this.currentAttempt,
      difficulty: difficulty ?? this.difficulty,
      startTime: startTime ?? this.startTime,
      gameMode: gameMode ?? this.gameMode,
      timerValue: timerValue ?? this.timerValue,
      initialTimeLimit: initialTimeLimit ?? this.initialTimeLimit,
      hintedIndices: hintedIndices ?? this.hintedIndices,
      hintsUsed: hintsUsed ?? this.hintsUsed,
      currentPuzzle: currentPuzzle ?? this.currentPuzzle,
      visibleEmojis: visibleEmojis ?? this.visibleEmojis,
    );
  }

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
    gameMode,
    timerValue,
    initialTimeLimit,
    hintedIndices,
    hintsUsed,
    currentPuzzle,
    visibleEmojis,
  ];
}