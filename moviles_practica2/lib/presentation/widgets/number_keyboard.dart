import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/game/game_bloc.dart';
import '../bloc/game/game_event.dart';
import 'key_button.dart';

class NumberKeyboard extends StatelessWidget {
  static const List<String> row1 = ['1', '2', '3'];
  static const List<String> row2 = ['4', '5', '6'];
  static const List<String> row3 = ['7', '8', '9'];
  static const List<String> row4 = ['ENTER', '0', 'DELETE'];
  const NumberKeyboard({super.key});
  @override
  Widget build(BuildContext context) {
    final gameBloc = context.read<GameBloc>();
    return Column(
      children: [
        _buildRow(row1, gameBloc),
        _buildRow(row2, gameBloc),
        _buildRow(row3, gameBloc),
        _buildRow(row4, gameBloc),
      ],
    );
  }
  Widget _buildRow(List<String> letters, GameBloc bloc) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: letters.map((letter) {
        if (letter == 'ENTER') {
          return KeyButton(
            letter: 'ENTER',
            flex: 2,
            onTap: () => bloc.add(SubmitWord()),
            icon: Icons.check,
            keyType: KeyType.confirm,
          );
        }
        if (letter == 'DELETE') {
          return KeyButton(
            letter: 'DELETE',
            flex: 2,
            onTap: () => bloc.add(DeleteKeyPressed()),
            icon: Icons.backspace_outlined,
            keyType: KeyType.delete,
          );
        }
        return KeyButton(
          letter: letter,
          flex: 1,
          onTap: () => bloc.add(LetterKeyPressed(letter: letter)),
        );
      }).toList(),
    );
  }
}