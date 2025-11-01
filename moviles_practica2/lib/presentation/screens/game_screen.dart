import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/game/game_bloc.dart';
import '../bloc/game/game_state.dart';
import '../widgets/game_grid.dart';
import '../widgets/game_keyboard.dart';
import '../bloc/game/game_event.dart';
import '../../data/providers/word_provider.dart';
import 'settings_screen.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<GameBloc, GameState>(
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
                    child: const Text('JUGAR DE NUEVO'),
                    onPressed: () {
                      Navigator.of(dialogContext).pop();
                      context.read<GameBloc>().add(StartNewGame(difficulty: context.read<GameBloc>().state.difficulty));
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
          // AÑADIMOS ESTA SECCIÓN
          actions: [
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                // 'Navigator.push' es la forma de abrir una nueva pantalla.
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const SettingsScreen(),
                  ),
                );
              },
            ),
          ],
        ),
        // AHORA el BlocBuilder solo envuelve lo que realmente necesita el estado para DIBUJARSE.
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
    );
  }
}