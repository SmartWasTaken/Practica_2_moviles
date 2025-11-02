import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/providers/word_provider.dart';
import '../bloc/game/game_bloc.dart';
import '../bloc/game/game_event.dart';
import '../bloc/game/game_state.dart';
import '../widgets/game_grid.dart';
import '../widgets/game_keyboard.dart';
import 'in_game_menu_screen.dart';
import '../routes/custom_page_route.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  void _openInGameMenu(BuildContext context) async {
    final result = await Navigator.of(context).push(
      FadePageRoute(
        page: const InGameMenuScreen(),
      ),
    );

    if (!context.mounted) return;

    if (result is Difficulty) {
      context.read<GameBloc>().add(StartNewGame(difficulty: result));
    } else if (result == 'exit') {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Envolvemos todo en PopScope para controlar el botón "atrás" del sistema.
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
                    state.gameStatus == GameStatus.win ? '🎉 ¡Has Ganado! 🎉' : '😔 ¡Has Perdido! 😔',
                  ),
                  content: Text('La palabra correcta era: ${state.correctWord}'),
                  actions: <Widget>[
                    TextButton(
                      child: const Text('SALIR AL MENÚ'),
                      onPressed: () {
                        Navigator.of(dialogContext).pop();
                        Navigator.of(context).pop();
                      },
                    ),
                    TextButton(
                      child: const Text('JUGAR DE NUEVO'),
                      onPressed: () {
                        Navigator.of(dialogContext).pop();
                        context.read<GameBloc>().add(StartNewGame(difficulty: state.difficulty));
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
          ),
          body: BlocBuilder<GameBloc, GameState>(
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