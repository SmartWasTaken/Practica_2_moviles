import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/models/score.dart';
import '../../../data/providers/word_provider.dart';
import '../../../data/repositories/game_repository.dart';
import 'game_event.dart';
import 'game_state.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  final GameRepository gameRepository;
  static const int maxAttempts = 8;

  GameBloc({required this.gameRepository}) : super(GameState.initial()) {
    on<StartNewGame>(_onStartNewGame);
    on<LetterKeyPressed>(_onLetterKeyPressed);
    on<DeleteKeyPressed>(_onDeleteKeyPressed);
    on<SubmitWord>(_onSubmitWord);
  }

  void _onStartNewGame(StartNewGame event, Emitter<GameState> emit) async {
    final word = await gameRepository.getWord(event.difficulty);
    final List<List<String>> initialGuesses = List.generate(maxAttempts, (_) => []);
    final List<List<LetterStatus>> initialStatuses = List.generate(maxAttempts, (_) => List.filled(word.length, LetterStatus.initial));

    emit(state.copyWith(
      correctWord: word,
      wordSize: word.length,
      gameStatus: GameStatus.playing,
      guesses: initialGuesses,
      statuses: initialStatuses,
      currentAttempt: 0,
      difficulty: event.difficulty,
      startTime: DateTime.now(),
    ));
  }

  void _onLetterKeyPressed(LetterKeyPressed event, Emitter<GameState> emit) {
    if (state.gameStatus == GameStatus.playing &&
        state.guesses[state.currentAttempt].length < state.wordSize) {
      final List<List<String>> newGuesses = state.guesses.map((list) => List<String>.from(list)).toList();
      newGuesses[state.currentAttempt].add(event.letter);
      emit(state.copyWith(guesses: newGuesses));
    }
  }

  void _onDeleteKeyPressed(DeleteKeyPressed event, Emitter<GameState> emit) {
    if (state.gameStatus == GameStatus.playing &&
        state.guesses[state.currentAttempt].isNotEmpty) {
      final List<List<String>> newGuesses = state.guesses.map((list) => List<String>.from(list)).toList();
      newGuesses[state.currentAttempt].removeLast();
      emit(state.copyWith(guesses: newGuesses));
    }
  }

  void _onSubmitWord(SubmitWord event, Emitter<GameState> emit) {
    if (state.gameStatus != GameStatus.playing ||
        state.guesses[state.currentAttempt].length != state.wordSize) {
      return;
    }

    final String guessedWord = state.guesses[state.currentAttempt].join();
    final String correctWord = state.correctWord;
    final List<LetterStatus> newStatuses = List.filled(state.wordSize, LetterStatus.initial);
    List<String> correctWordLetters = correctWord.split('');

    for (int i = 0; i < guessedWord.length; i++) {
      if (guessedWord[i] == correctWord[i]) {
        newStatuses[i] = LetterStatus.correctPosition;
        correctWordLetters[i] = '';
      }
    }

    for (int i = 0; i < guessedWord.length; i++) {
      if (newStatuses[i] == LetterStatus.initial) {
        if (correctWordLetters.contains(guessedWord[i])) {
          newStatuses[i] = LetterStatus.inWord;
          correctWordLetters.remove(guessedWord[i]);
        } else {
          newStatuses[i] = LetterStatus.notInWord;
        }
      }
    }

    final List<List<LetterStatus>> updatedStatuses = state.statuses.map((list) => List<LetterStatus>.from(list)).toList();
    updatedStatuses[state.currentAttempt] = newStatuses;

    GameStatus newGameStatus = GameStatus.playing;
    if (guessedWord == correctWord) {
      newGameStatus = GameStatus.win;
    } else if (state.currentAttempt >= maxAttempts - 1) {
      newGameStatus = GameStatus.lose;
    }

    if (newGameStatus == GameStatus.win) {
      final endTime = DateTime.now();
      final timeInSeconds = state.startTime != null
          ? endTime.difference(state.startTime!).inSeconds
          : 0;

      final scoreValue = _calculateScore(
        state.difficulty,
        state.currentAttempt + 1,
        timeInSeconds,
      );

      final newScore = Score(
        scoreValue: scoreValue,
        difficulty: state.difficulty,
        timeInSeconds: timeInSeconds,
        attempts: state.currentAttempt + 1,
        date: DateTime.now(),
      );
      gameRepository.saveScore(newScore);
    }

    emit(state.copyWith(
      statuses: updatedStatuses,
      gameStatus: newGameStatus,
      currentAttempt: newGameStatus == GameStatus.playing ? state.currentAttempt + 1 : state.currentAttempt,
    ));
  }

  int _calculateScore(Difficulty difficulty, int attempts, int timeInSeconds) {
    int baseScore = 0;
    int attemptBonusMultiplier = 0;
    int timeBonusMultiplier = 0;

    switch (difficulty) {
      case Difficulty.facil:
        baseScore = 1000;
        attemptBonusMultiplier = 50;
        timeBonusMultiplier = 5;
        break;
      case Difficulty.medio:
        baseScore = 2500;
        attemptBonusMultiplier = 100;
        timeBonusMultiplier = 10;
        break;
      case Difficulty.dificil:
        baseScore = 5000;
        attemptBonusMultiplier = 150;
        timeBonusMultiplier = 15;
        break;
    }

    final attemptBonus = (maxAttempts - attempts) * attemptBonusMultiplier;
    final timeBonus = (300 - timeInSeconds).clamp(0, 300) * timeBonusMultiplier;

    return baseScore + attemptBonus + timeBonus;
  }
}