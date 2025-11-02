import 'package:flutter/material.dart';
import '../bloc/game/game_state.dart';
import 'letter_tile.dart';

class GameGrid extends StatelessWidget {
  final int wordSize;
  final List<List<String>> guesses;
  final List<List<LetterStatus>> statuses;

  const GameGrid({
    super.key,
    required this.wordSize,
    required this.guesses,
    required this.statuses,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final List<Widget> rows = [];
        for (int i = 0; i < guesses.length; i++) {
          final List<Widget> tiles = [];
          for (int j = 0; j < wordSize; j++) {
            final String letter = (j < guesses[i].length) ? guesses[i][j] : '';
            final LetterStatus status = (j < statuses[i].length) ? statuses[i][j] : LetterStatus.initial;

            tiles.add(
              LetterTile(letter: letter, status: status),
            );
          }
          rows.add(
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: tiles,
            ),
          );
        }

        return Column(
          children: rows,
        );
      },
    );
  }
}