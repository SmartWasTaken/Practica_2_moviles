import 'dart:async';
import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/enums.dart';
import '../../../core/models/emoji_puzzle.dart';
import '../../../core/models/score.dart';
import '../../../data/repositories/game_repository.dart';
import 'game_event.dart';
import 'game_state.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  final GameRepository gameRepository;
  static const int maxAttempts = 8;
  static const int maxHints = 2;
  Timer? _timer;

  GameBloc({required this.gameRepository}) : super(GameState.initial()) {
    on<StartNewGame>(_onStartNewGame);
    on<TimerTicked>(_onTimerTicked);
    on<LetterKeyPressed>(_onLetterKeyPressed);
    on<DeleteKeyPressed>(_onDeleteKeyPressed);
    on<SubmitWord>(_onSubmitWord);
    on<HintRequested>(_onHintRequested);
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }

  void _onStartNewGame(StartNewGame event, Emitter<GameState> emit) async {
    _timer?.cancel();

    String correctWord;
    int wordSize;
    EmojiPuzzle? puzzle;
    List<String> visibleEmojis = [];

    if (event.gameMode == GameMode.numbers) {
      correctWord = await gameRepository.getNumber(event.difficulty);
      wordSize = correctWord.length;
      puzzle = null;
    } else if (event.gameMode == GameMode.emojis) {
      puzzle = await gameRepository.getEmojiPuzzle(event.difficulty);
      correctWord = puzzle.name;
      wordSize = puzzle.name.length;
      if (puzzle.emojis.isNotEmpty) {
        visibleEmojis = [puzzle.emojis.first];
      }
    } else {
      correctWord = await gameRepository.getWord(event.difficulty);
      wordSize = correctWord.length;
      puzzle = null;
    }

    final List<List<String>> initialGuesses = List.generate(maxAttempts, (_) => []);
    final List<List<LetterStatus>> initialStatuses = List.generate(maxAttempts, (_) => List.filled(wordSize, LetterStatus.initial));
    final initialTime = event.gameMode == GameMode.timeTrial ? event.timeLimit! : Duration.zero;

    emit(state.copyWith(
      correctWord: correctWord,
      wordSize: wordSize,
      gameStatus: GameStatus.playing,
      guesses: initialGuesses,
      statuses: initialStatuses,
      currentAttempt: 0,
      difficulty: event.difficulty,
      startTime: DateTime.now(),
      gameMode: event.gameMode,
      timerValue: initialTime,
      initialTimeLimit: event.gameMode == GameMode.timeTrial ? event.timeLimit : null,
      hintedIndices: [],
      hintsUsed: 0,
      currentPuzzle: puzzle,
      visibleEmojis: visibleEmojis,
    ));

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.gameStatus == GameStatus.playing) {
        if (state.gameMode == GameMode.normal ||
            state.gameMode == GameMode.competitive ||
            state.gameMode == GameMode.numbers ||
            state.gameMode == GameMode.emojis) {
          add(TimerTicked(state.timerValue + const Duration(seconds: 1)));
        }
        else if (state.gameMode == GameMode.timeTrial) {
          add(TimerTicked(state.timerValue - const Duration(seconds: 1)));
        }
      }
    });
  }

  void _onTimerTicked(TimerTicked event, Emitter<GameState> emit) {
    if (state.gameStatus != GameStatus.playing) {
      _timer?.cancel();
      return;
    }

    if (state.gameMode == GameMode.timeTrial && event.duration.inSeconds <= 0) {
      emit(state.copyWith(timerValue: Duration.zero, gameStatus: GameStatus.lose));
      _timer?.cancel();
    } else {
      emit(state.copyWith(timerValue: event.duration));
    }
  }

  void _onLetterKeyPressed(LetterKeyPressed event, Emitter<GameState> emit) {
    if (state.gameStatus == GameStatus.playing && state.guesses[state.currentAttempt].length < state.wordSize) {
      final List<List<String>> newGuesses = state.guesses.map((list) => List<String>.from(list)).toList();
      newGuesses[state.currentAttempt].add(event.letter);
      emit(state.copyWith(guesses: newGuesses));
    }
  }

  void _onDeleteKeyPressed(DeleteKeyPressed event, Emitter<GameState> emit) {
    if (state.gameStatus == GameStatus.playing && state.guesses[state.currentAttempt].isNotEmpty) {
      final List<List<String>> newGuesses = state.guesses.map((list) => List<String>.from(list)).toList();
      newGuesses[state.currentAttempt].removeLast();
      emit(state.copyWith(guesses: newGuesses));
    }
  }

  void _onSubmitWord(SubmitWord event, Emitter<GameState> emit) {
    if (state.gameStatus != GameStatus.playing || state.guesses[state.currentAttempt].length != state.wordSize) {
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

    List<String> newVisibleEmojis = state.visibleEmojis;
    int nextAttempt = state.currentAttempt;

    if (newGameStatus == GameStatus.win || newGameStatus == GameStatus.lose) {
      _timer?.cancel();
      if (newGameStatus == GameStatus.win) {
        final endTime = DateTime.now();
        final timeInSeconds = state.startTime != null ? endTime.difference(state.startTime!).inSeconds : 0;
        final scoreValue = _calculateScore(state.difficulty, state.currentAttempt + 1, timeInSeconds);
        final newScore = Score(
          scoreValue: scoreValue,
          difficulty: state.difficulty,
          gameMode: state.gameMode,
          timeInSeconds: timeInSeconds,
          attempts: state.currentAttempt + 1,
          date: DateTime.now(),
        );
        gameRepository.saveScore(newScore);
      }
    } else if (newGameStatus == GameStatus.playing) {
      nextAttempt = state.currentAttempt + 1;

      if (state.gameMode == GameMode.emojis) {
        if (nextAttempt < state.currentPuzzle!.emojis.length) {
          newVisibleEmojis = state.currentPuzzle!.emojis.sublist(0, nextAttempt + 1);
        } else {
          newVisibleEmojis = state.currentPuzzle!.emojis;
        }
      }
    }

    emit(state.copyWith(
      statuses: updatedStatuses,
      gameStatus: newGameStatus,
      currentAttempt: nextAttempt,
      visibleEmojis: newVisibleEmojis,
    ));
  }

  void _onHintRequested(HintRequested event, Emitter<GameState> emit) {
    if (state.gameMode == GameMode.competitive ||
        state.gameMode == GameMode.numbers ||
        state.gameMode == GameMode.emojis) return;
    if (state.gameStatus != GameStatus.playing) return;
    if (state.currentAttempt >= maxAttempts - 1) return;
    if (state.hintsUsed >= maxHints) return;

    final correctWord = state.correctWord.split('');
    final hintedIndices = state.hintedIndices;

    final Set<int> alreadyGreenIndices = {};
    for (int i = 0; i < state.currentAttempt; i++) {
      for (int j = 0; j < state.statuses[i].length; j++) {
        if (state.statuses[i][j] == LetterStatus.correctPosition) {
          alreadyGreenIndices.add(j);
        }
      }
    }
    final allIndices = List.generate(correctWord.length, (i) => i);
    final availableHintIndices = allIndices.where((i) =>
    !hintedIndices.contains(i) &&
        !alreadyGreenIndices.contains(i)
    ).toList();

    if (availableHintIndices.isEmpty) {
      return;
    }

    final random = Random();
    final indexToReveal = availableHintIndices[random.nextInt(availableHintIndices.length)];
    final letterToReveal = correctWord[indexToReveal];

    final newHintedGuess = List.filled(state.wordSize, '');
    final newHintedStatus = List.filled(state.wordSize, LetterStatus.initial);

    newHintedGuess[indexToReveal] = letterToReveal;
    newHintedStatus[indexToReveal] = LetterStatus.correctPosition;

    final newGuesses = state.guesses.map((list) => List<String>.from(list)).toList();
    final newStatuses = state.statuses.map((list) => List<LetterStatus>.from(list)).toList();

    newGuesses[state.currentAttempt] = newHintedGuess;
    newStatuses[state.currentAttempt] = newHintedStatus;

    final newHintedIndices = List<int>.from(hintedIndices)..add(indexToReveal);

    emit(state.copyWith(
      guesses: newGuesses,
      statuses: newStatuses,
      hintedIndices: newHintedIndices,
      currentAttempt: state.currentAttempt + 1,
      hintsUsed: state.hintsUsed + 1,
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