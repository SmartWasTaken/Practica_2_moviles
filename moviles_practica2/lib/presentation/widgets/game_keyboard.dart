import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/game/game_bloc.dart';
import '../bloc/game/game_event.dart';
import 'key_button.dart';

class GameKeyboard extends StatelessWidget {
  // Definimos la disposición de las teclas en filas
  static const List<String> row1 = ['Q', 'W', 'E', 'R', 'T', 'Y', 'U', 'I', 'O', 'P'];
  static const List<String> row2 = ['A', 'S', 'D', 'F', 'G', 'H', 'J', 'K', 'L', 'Ñ'];
  static const List<String> row3 = ['ENTER', 'Z', 'X', 'C', 'V', 'B', 'N', 'M', 'DELETE'];

  const GameKeyboard({super.key});

  @override
  Widget build(BuildContext context) {
    final gameBloc = context.read<GameBloc>();

    return Column(
      children: [
        _buildRow(row1, gameBloc),
        _buildRow(row2, gameBloc),
        _buildRow(row3, gameBloc),
      ],
    );
  }

  // Método helper para construir una fila de teclas
  Widget _buildRow(List<String> letters, GameBloc bloc) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: letters.map((letter) {
        if (letter == 'ENTER') {
          return KeyButton(
            letter: 'ENTER',
            flex: 2, // Hacemos que sea más ancha
            onTap: () => bloc.add(SubmitWord()),
            icon: Icons.check,
          );
        }
        if (letter == 'DELETE') {
          return KeyButton(
            letter: 'DELETE',
            flex: 2, // Hacemos que sea más ancha
            onTap: () => bloc.add(DeleteKeyPressed()),
            icon: Icons.backspace_outlined,
          );
        }
        return KeyButton(
          letter: letter,
          onTap: () => bloc.add(LetterKeyPressed(letter: letter)),
        );
      }).toList(),
    );
  }
}