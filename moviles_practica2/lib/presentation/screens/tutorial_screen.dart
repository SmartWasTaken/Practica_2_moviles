import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/constants/enums.dart';
import '../bloc/tutorial/tutorial_bloc.dart';
import '../bloc/tutorial/tutorial_event.dart';
import '../bloc/tutorial/tutorial_state.dart';
import '../widgets/game_grid.dart';
import '../widgets/tutorial_keyboard.dart';

class TutorialScreen extends StatelessWidget {
  const TutorialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TutorialBloc()..add(StartTutorial()),
      child: const TutorialView(),
    );
  }
}

class TutorialView extends StatelessWidget {
  const TutorialView({super.key});

  void _showInstructionDialog(BuildContext context, TutorialState state) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(state.instructionTitle),
          content: Text(state.instructionText),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                context.read<TutorialBloc>().add(TutorialNextStep());
              },
              child: const Text('Siguiente'),
            ),
          ],
        );
      },
    );
  }

  void _showDifficultyChoice(BuildContext context, TutorialState state) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(state.instructionTitle),
          content: Text(state.instructionText),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                context.read<TutorialBloc>().add(const TutorialDifficultyChosen(difficulty: Difficulty.medio));
              },
              child: const Text('Medio'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                context.read<TutorialBloc>().add(const TutorialDifficultyChosen(difficulty: Difficulty.dificil));
              },
              child: const Text('Difícil'),
            ),
          ],
        );
      },
    );
  }

  void _showHintExplanation(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Sistema de pistas'),
        content: const Text('💡 Este es el botón de pista. En una partida real, si lo pulsas, te costará 1 intento y te revelará una letra correcta. Además, tendrás únicamente dos intentos.\n\n(No puedes usarla en tu último turno).'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Entendido'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TutorialBloc, TutorialState>(
      listener: (context, state) {
        if (state.stage == TutorialStage.step1_Welcome ||
            state.stage == TutorialStage.step3_ExplainColors ||
            state.stage == TutorialStage.step3b_ExplainHints) {
          _showInstructionDialog(context, state);
        } else if (state.stage == TutorialStage.step4_ChooseDifficulty) {
          _showDifficultyChoice(context, state);
        } else if (state.stage == TutorialStage.step7_FinalCongrats) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (dialogContext) {
              return AlertDialog(
                title: Text(state.instructionTitle),
                content: Text(state.instructionText),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(dialogContext).pop();
                      context.read<TutorialBloc>().add(TutorialNextStep());
                      Navigator.of(context).pop();
                    },
                    child: const Text('¡A jugar!'),
                  ),
                ],
              );
            },
          );
        }
      },
      builder: (context, state) {
        const gameplayStages = [
          TutorialStage.step2_GuessHOLA,
          TutorialStage.step5_GuessJUGAR,
          TutorialStage.step6_GuessJARDIN,
        ];

        final showPersistentInstruction = gameplayStages.contains(state.stage);
        final bool isLoading = state.stage == TutorialStage.initial || state.stage == TutorialStage.step1_Welcome;

        if (isLoading) {
          return Scaffold(
            appBar: AppBar(title: const Text('Tutorial')),
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Tutorial'),
            bottom: showPersistentInstruction
                ? PreferredSize(
              preferredSize: const Size.fromHeight(80.0),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12.0),
                color: Colors.grey.shade800,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(state.instructionTitle, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 4),
                    Text(state.instructionText),
                  ],
                ),
              ),
            )
                : null,
          ),
          body: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: GameGrid(
                          wordSize: state.correctWord.length,
                          guesses: state.guesses,
                          statuses: state.statuses,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: TextButton.icon(
                          onPressed: () => _showHintExplanation(context),
                          icon: const Icon(Icons.lightbulb_outline),
                          label: const Text('PISTA'),
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
                        child: IgnorePointer(
                          ignoring: !state.keyboardEnabled,
                          child: Opacity(
                            opacity: state.keyboardEnabled ? 1.0 : 0.5,
                            child: const TutorialKeyboard(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}