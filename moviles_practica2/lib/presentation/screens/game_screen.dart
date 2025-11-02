import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/constants/enums.dart';
import '../bloc/game/game_bloc.dart';
import '../bloc/game/game_event.dart';
import '../bloc/game/game_state.dart';
import '../routes/custom_page_route.dart';
import '../widgets/game_grid.dart';
import '../widgets/game_keyboard.dart';
import 'in_game_menu_screen.dart';
import 'ranking_screen.dart'; // <-- AÑADIMOS LA IMPORTACIÓN PARA EL RANKING

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
        gameMode: context.read<GameBloc>().state.gameMode,
        timeLimit: currentState.initialTimeLimit,
      ));
    } else if (result == 'exit') {
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
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
                        Navigator.of(context).popUntil((route) => route.isFirst);
                      },
                    ),

                    TextButton(
                      child: const Text('IR AL RANKING'),
                      onPressed: () {
                        final navigator = Navigator.of(context, rootNavigator: true);
                        Navigator.of(dialogContext).pop();
                        Navigator.of(context).popUntil((route) => route.isFirst);
                        Navigator.of(context).push(FadePageRoute(page: const RankingScreen()));
                      },
                    ),

                    // --- Botón "JUGAR DE NUEVO" (sin cambios) ---
                    TextButton(
                      child: const Text('JUGAR DE NUEVO'),
                      onPressed: () {
                        Navigator.of(dialogContext).pop();
                        final currentState = context.read<GameBloc>().state;
                        context.read<GameBloc>().add(StartNewGame(
                          difficulty: state.difficulty,
                          gameMode: state.gameMode,
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
          appBar: AppBar(
            title: const Text('Wordle'),
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
          body: BlocBuilder<GameBloc, GameState>(
            // ... (el body no cambia)
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
                            padding: const EdgeInsets.only(top: 16.0),
                            child: GameGrid(
                              wordSize: state.wordSize,
                              guesses: state.guesses,
                              statuses: state.statuses,
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
                            child: GameKeyboard(),
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
    );
  }
}