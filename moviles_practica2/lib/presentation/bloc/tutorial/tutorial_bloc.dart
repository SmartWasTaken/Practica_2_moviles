import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/enums.dart';
import 'tutorial_event.dart';
import 'tutorial_state.dart';

class TutorialBloc extends Bloc<TutorialEvent, TutorialState> {
  TutorialBloc() : super(TutorialState.initial()) {
    on<StartTutorial>(_onStartTutorial);
    on<TutorialNextStep>(_onNextStep);
    on<TutorialLetterKeyPressed>(_onLetterKeyPressed);
    on<TutorialDeleteKeyPressed>(_onDeleteKeyPressed);
    on<TutorialSubmitWord>(_onSubmitWord);
    on<TutorialDifficultyChosen>(_onDifficultyChosen);
  }

  void _setupBoard(Emitter<TutorialState> emit, String word, String title, String text, TutorialStage stage, bool keyboard) {
    emit(state.copyWith(
      stage: stage,
      correctWord: word,
      guesses: List.generate(state.maxAttempts, (_) => []),
      statuses: List.generate(state.maxAttempts, (_) => List.filled(word.length, LetterStatus.initial)),
      currentAttempt: 0,
      instructionTitle: title,
      instructionText: text,
      keyboardEnabled: keyboard,
    ));
  }

  void _onStartTutorial(StartTutorial event, Emitter<TutorialState> emit) {
    emit(state.copyWith(
      stage: TutorialStage.step1_Welcome,
      instructionTitle: '¡Bienvenido!',
      instructionText: 'Vamos a jugar una partida de prueba para aprender las reglas.',
      keyboardEnabled: false,
    ));
  }

  void _onNextStep(TutorialNextStep event, Emitter<TutorialState> emit) {
    switch (state.stage) {
      case TutorialStage.step1_Welcome:
        _setupBoard(
          emit,
          'HOLA',
          'Adivina la Palabra',
          'Intenta adivinar la palabra de 4 letras. Prueba con "GATO" y pulsa Enter.',
          TutorialStage.step2_GuessHOLA,
          true,
        );
        break;

      case TutorialStage.step3_ExplainColors:
        emit(state.copyWith(
          stage: TutorialStage.step3b_ExplainHints,
          instructionTitle: 'Sistema de pistas',
          instructionText: '💡 Si te atascas, pulsa el botón PISTA.\n\nSe revelará una letra correcta, ¡pero te costará 1 intento!\n\n(No puedes usarla en tu último turno).',
          keyboardEnabled: false,
        ));
        break;

      case TutorialStage.step3b_ExplainHints:
        emit(state.copyWith(
          stage: TutorialStage.step2_GuessHOLA,
          instructionTitle: '¡Ahora tú!',
          instructionText: 'Intenta adivinar la palabra de 4 letras.',
          keyboardEnabled: true,
        ));
        break;

      case TutorialStage.step7_FinalCongrats:
        emit(TutorialState.initial());
        break;
      default:
        break;
    }
  }

  void _onDifficultyChosen(TutorialDifficultyChosen event, Emitter<TutorialState> emit) {
    if (event.difficulty == Difficulty.medio) {
      _setupBoard(
        emit,
        'JUGAR',
        'Ronda de práctica (Media)',
        'Intenta adivinar la palabra de 5 letras.',
        TutorialStage.step5_GuessJUGAR,
        true,
      );
    } else {
      _setupBoard(
        emit,
        'JARDIN',
        'Ronda de práctica (Difícil)',
        'Intenta adivinar la palabra de 6 letras.',
        TutorialStage.step6_GuessJARDIN,
        true,
      );
    }
  }

  void _onLetterKeyPressed(TutorialLetterKeyPressed event, Emitter<TutorialState> emit) {
    if (!state.keyboardEnabled) return;
    if (state.currentAttempt < state.maxAttempts && state.guesses[state.currentAttempt].length < state.correctWord.length) {
      final newGuesses = state.guesses.map((list) => List<String>.from(list)).toList();
      newGuesses[state.currentAttempt].add(event.letter);
      emit(state.copyWith(guesses: newGuesses));
    }
  }

  void _onDeleteKeyPressed(TutorialDeleteKeyPressed event, Emitter<TutorialState> emit) {
    if (!state.keyboardEnabled) return;
    if (state.currentAttempt < state.maxAttempts && state.guesses[state.currentAttempt].isNotEmpty) {
      final newGuesses = state.guesses.map((list) => List<String>.from(list)).toList();
      newGuesses[state.currentAttempt].removeLast();
      emit(state.copyWith(guesses: newGuesses));
    }
  }

  void _onSubmitWord(TutorialSubmitWord event, Emitter<TutorialState> emit) {
    if (!state.keyboardEnabled) return;

    final guessList = state.guesses[state.currentAttempt];
    if (guessList.length != state.correctWord.length) return;

    final String guessedWord = guessList.join();
    final String correctWord = state.correctWord;
    final newStatuses = List.filled(correctWord.length, LetterStatus.initial);
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

    final newGuesses = state.guesses.map((list) => List<String>.from(list)).toList();
    final newStatusesLists = state.statuses.map((list) => List<LetterStatus>.from(list)).toList();
    newStatusesLists[state.currentAttempt] = newStatuses;

    bool playerWon = guessedWord == correctWord;

    emit(state.copyWith(
      guesses: newGuesses,
      statuses: newStatusesLists,
      currentAttempt: playerWon ? state.currentAttempt : state.currentAttempt + 1,
    ));

    if (state.stage == TutorialStage.step2_GuessHOLA) {
      if (playerWon) {
        emit(state.copyWith(
          stage: TutorialStage.step4_ChooseDifficulty,
          instructionTitle: '¡Perfecto!',
          instructionText: '¡Lo has pillado! Ahora, elige una dificultad para la siguiente ronda.',
          keyboardEnabled: false,
        ));
      } else if (state.currentAttempt == 1) {
        emit(state.copyWith(
          stage: TutorialStage.step3_ExplainColors,
          instructionTitle: '¡Mira los colores!',
          instructionText: '🟩 Verde: Letra y posición correctas.\n🟨 Amarillo: Letra correcta, posición incorrecta.\n⬜ Gris: Letra incorrecta.',
          keyboardEnabled: false,
        ));
      } else if (state.currentAttempt >= state.maxAttempts) {
        emit(state.copyWith(
          stage: TutorialStage.step4_ChooseDifficulty,
          instructionTitle: '¡No te preocupes!',
          instructionText: 'La palabra era "HOLA". ¡Lo importante es que ya sabes cómo funciona! Vamos a continuar.',
          keyboardEnabled: false,
        ));
      }
    }
    else if (state.stage == TutorialStage.step5_GuessJUGAR || state.stage == TutorialStage.step6_GuessJARDIN) {
      if (playerWon || state.currentAttempt >= state.maxAttempts) {
        emit(state.copyWith(
          stage: TutorialStage.step7_FinalCongrats,
          instructionTitle: '¡Tutorial completado!',
          instructionText: '¡Ya estás listo para jugar de verdad! Volverás al menú principal.',
          keyboardEnabled: false,
        ));
      }
    }
  }
}