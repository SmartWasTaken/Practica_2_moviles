import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/constants/enums.dart';
import '../bloc/game/game_bloc.dart';
import '../bloc/game/game_event.dart';
import '../bloc/game/game_state.dart';
import '../routes/custom_page_route.dart';
import '../widgets/game_background.dart';
import '../widgets/game_grid.dart';
import '../widgets/game_keyboard.dart';
import '../widgets/number_keyboard.dart';
import 'in_game_menu_screen.dart';
import 'ranking_screen.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  void _openInGameMenu(BuildContext context) async {
    final result = await Navigator.of(context).push(
      FadePageRoute(page: const InGameMenuScreen()),
    );

    if (!context.mounted) return;

    if (result is Difficulty) {
      final currentState = context.read<GameBloc>().state;
      context.read<GameBloc>().add(StartNewGame(
        difficulty: result,
        gameMode: currentState.gameMode,
        timeLimit: currentState.initialTimeLimit,
      ));
    } else if (result == 'exit') {
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
  }

  void _showHintConfirmation(BuildContext context) {
    final bloc = context.read<GameBloc>();
    final state = bloc.state;

    if (state.hintsUsed >= GameBloc.maxHints) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('No te quedan pistas'),
          content: const Text('Has usado tus 2 pistas. ¡Suerte adivinando!'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Entendido'),
            ),
          ],
        ),
      );
      return;
    }

    if (state.currentAttempt >= GameBloc.maxAttempts - 1) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Pista no disponible'),
          content: const Text('No puedes usar una pista en tu último intento.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Entendido'),
            ),
          ],
        ),
      );
      return;
    }

    final Set<int> alreadyGreenIndices = {};
    for (int i = 0; i < state.currentAttempt; i++) {
      for (int j = 0; j < state.statuses[i].length; j++) {
        if (state.statuses[i][j] == LetterStatus.correctPosition) {
          alreadyGreenIndices.add(j);
        }
      }
    }
    final allIndices = List.generate(state.correctWord.length, (i) => i);
    final availableHintIndices = allIndices.where((i) =>
    !state.hintedIndices.contains(i) &&
        !alreadyGreenIndices.contains(i)
    ).toList();

    if (availableHintIndices.isEmpty) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Pista no disponible'),
          content: const Text('¡No quedan pistas útiles por dar! Ya has encontrado (o te hemos dado) todas las letras en su posición correcta.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Entendido'),
            ),
          ],
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('¿Usar una Pista?'),
        content: Text(
          'Esto usará 1 de tus ${GameBloc.maxAttempts} intentos y 1 de tus 2 pistas.\n\nSe revelará una letra correcta. ¿Estás seguro?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              bloc.add(HintRequested());
            },
            child: const Text('Aceptar'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmojiPanel(BuildContext context, GameState state) {
    if (state.gameMode != GameMode.emojis || state.currentPuzzle == null) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
      margin: const EdgeInsets.only(bottom: 16.0),
      decoration: BoxDecoration(
        color: Colors.grey.shade800,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            state.currentPuzzle!.theme,
            style: TextStyle(fontSize: 14, color: Colors.grey.shade400, fontStyle: FontStyle.italic),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: state.visibleEmojis
                .map((emoji) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Text(emoji, style: const TextStyle(fontSize: 28)),
            ))
                .toList(),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, dynamic result) {
        if (!didPop) {
          _openInGameMenu(context);
        }
      },
      child: BlocListener<GameBloc, GameState>(
        listener: (context, state) {
          if (state.gameStatus == GameStatus.win || state.gameStatus == GameStatus.lose) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (dialogContext) {
                return AlertDialog(
                  title: Text(
                    state.gameStatus == GameStatus.win ? '¡Has Ganado!' : '¡Has Perdido!',
                  ),
                  content: Text('La palabra correcta era: ${state.correctWord}'),
                  actions: <Widget>[
                    TextButton(
                      child: const Text('SALIR AL MENÚ'),
                      onPressed: () {
                        final navigator = Navigator.of(context, rootNavigator: true);
                        Navigator.of(dialogContext).pop();
                        navigator.popUntil((route) => route.isFirst);
                      },
                    ),
                    TextButton(
                      child: const Text('IR AL RANKING'),
                      onPressed: () {
                        final navigator = Navigator.of(context, rootNavigator: true);
                        Navigator.of(dialogContext).pop();
                        navigator.popUntil((route) => route.isFirst);
                        navigator.push(FadePageRoute(page: const RankingScreen()));
                      },
                    ),
                    TextButton(
                      child: const Text('JUGAR DE NUEVO'),
                      onPressed: () {
                        Navigator.of(dialogContext).pop();
                        final currentState = context.read<GameBloc>().state;
                        context.read<GameBloc>().add(StartNewGame(
                          difficulty: currentState.difficulty,
                          gameMode: currentState.gameMode,
                          timeLimit: currentState.initialTimeLimit,
                        ));
                      },
                    ),
                  ],
                );
              },
            );
          }
        },
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: const Text('PALAZLE'),
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            automaticallyImplyLeading: false,
            leading: IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () => _openInGameMenu(context),
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(30.0),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: BlocBuilder<GameBloc, GameState>(
                  builder: (context, state) {
                    final minutes = state.timerValue.inMinutes.toString().padLeft(2, '0');
                    final seconds = (state.timerValue.inSeconds % 60).toString().padLeft(2, '0');
                    return Text(
                      '$minutes:$seconds',
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    );
                  },
                ),
              ),
            ),
          ),
          body: GameBackground(
            child: BlocBuilder<GameBloc, GameState>(
            builder: (context, state) {
              if (state.gameStatus == GameStatus.initial) {
                return const Center(child: CircularProgressIndicator());
              }
              return LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(minHeight: constraints.maxHeight),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
                            child: Column(
                              children: [
                                _buildEmojiPanel(context, state),
                                GameGrid(
                                  wordSize: state.wordSize,
                                  guesses: state.guesses,
                                  statuses: state.statuses,
                                ),
                              ],
                            ),
                          ),

                          if (state.gameMode != GameMode.competitive &&
                              state.gameMode != GameMode.numbers &&
                              state.gameMode != GameMode.emojis)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: BlocBuilder<GameBloc, GameState>(
                                builder: (context, state) {
                                  final hintsLeft = GameBloc.maxHints - state.hintsUsed;
                                  return TextButton.icon(
                                    onPressed: () => _showHintConfirmation(context),
                                    icon: const Icon(Icons.lightbulb_outline),
                                    label: Text('PISTA ($hintsLeft / ${GameBloc.maxHints})'),
                                    style: TextButton.styleFrom(
                                      foregroundColor: Colors.white,
                                    ),
                                  );
                                },
                              ),
                            ),

                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
                            child: state.gameMode == GameMode.numbers
                                ? const NumberKeyboard()
                                : const GameKeyboard(),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    ));
  }
}