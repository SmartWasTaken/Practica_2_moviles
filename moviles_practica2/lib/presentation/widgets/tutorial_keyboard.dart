import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/tutorial/tutorial_bloc.dart';
import '../bloc/tutorial/tutorial_event.dart';
import 'key_button.dart';

class TutorialKeyboard extends StatelessWidget {
  static const List<String> row1 = ['Q', 'W', 'E', 'R', 'T', 'Y', 'U', 'I', 'O', 'P'];
  static const List<String> row2 = ['A', 'S', 'D', 'F', 'G', 'H', 'J', 'K', 'L', 'Ñ'];
  static const List<String> row3 = ['ENTER', 'Z', 'X', 'C', 'V', 'B', 'N', 'M', 'DELETE'];

  const TutorialKeyboard({super.key});

  @override
  Widget build(BuildContext context) {
    final tutorialBloc = context.read<TutorialBloc>();

    return Column(
      children: [
        _buildRow(row1, tutorialBloc),
        _buildRow(row2, tutorialBloc),
        _buildRow(row3, tutorialBloc),
      ],
    );
  }

  Widget _buildRow(List<String> letters, TutorialBloc bloc) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: letters.map((letter) {
        if (letter == 'ENTER') {
          return KeyButton(
            letter: 'ENTER',
            flex: 2,
            onTap: () => bloc.add(TutorialSubmitWord()),
            icon: Icons.check,
            keyType: KeyType.confirm,
          );
        }
        if (letter == 'DELETE') {
          return KeyButton(
            letter: 'DELETE',
            flex: 2,
            onTap: () => bloc.add(TutorialDeleteKeyPressed()),
            icon: Icons.backspace_outlined,
            keyType: KeyType.delete,
          );
        }
        return KeyButton(
          letter: letter,
          onTap: () => bloc.add(TutorialLetterKeyPressed(letter: letter)),
        );
      }).toList(),
    );
  }
}