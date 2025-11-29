import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/settings/settings_bloc.dart';

enum KeyType { letter, confirm, delete }

class KeyButton extends StatelessWidget {
  final String letter;
  final IconData? icon;
  final VoidCallback onTap;
  final int flex;
  final KeyType keyType;

  const KeyButton({
    super.key,
    required this.letter,
    required this.onTap,
    this.icon,
    this.flex = 1,
    this.keyType = KeyType.letter,
  });

  Color _getBackgroundColor(BuildContext context, bool highContrast) {
    switch (keyType) {
      case KeyType.confirm:
        return highContrast ? Colors.orange.shade800 : Colors.green.shade800;
      case KeyType.delete:
        return Colors.red.shade800;
      case KeyType.letter:
      default:
        return Colors.grey.shade800;
    }
  }

  @override
  Widget build(BuildContext context) {
    final settingsState = context.watch<SettingsBloc>().state;
    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Material(
          color: _getBackgroundColor(context, settingsState.isHighContrast),
          borderRadius: BorderRadius.circular(4),
          child: InkWell(
            onTap: () {
              if (settingsState.isHapticsEnabled) {
                HapticFeedback.lightImpact();
              }
              onTap();
            },
            borderRadius: BorderRadius.circular(4),
            child: Container(
              height: 50,
              alignment: Alignment.center,
              child: icon != null
                  ? Icon(icon, color: Colors.white)
                  : Text(
                letter.toUpperCase(),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}