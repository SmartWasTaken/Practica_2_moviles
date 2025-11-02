import 'package:flutter/material.dart';
import '../../core/constants/enums.dart';
import '../bloc/game/game_state.dart';

class LetterTile extends StatelessWidget {
  final String letter;
  final LetterStatus status;

  const LetterTile({
    super.key,
    required this.letter,
    required this.status,
  });

  Color _getBackgroundColor(BuildContext context) {
    switch (status) {
      case LetterStatus.correctPosition:
        return Colors.green.shade700;
      case LetterStatus.inWord:
        return Colors.amber.shade700;
      case LetterStatus.notInWord:
        return Theme.of(context).colorScheme.secondary.withOpacity(0.5);
      case LetterStatus.initial:
      default:
        return Colors.transparent;
    }
  }

  Color _getBorderColor(BuildContext context) {
    return letter.isEmpty
        ? Theme.of(context).dividerColor
        : Theme.of(context).colorScheme.secondary;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      alignment: Alignment.center,
      margin: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: _getBackgroundColor(context),
        border: Border.all(
          color: _getBorderColor(context),
          width: 2,
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        letter.toUpperCase(),
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}