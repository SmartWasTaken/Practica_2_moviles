import 'package:flutter/material.dart';

class KeyButton extends StatelessWidget {
  // El texto a mostrar (ej: 'Q')
  final String letter;
  // El icono a mostrar (ej: un backspace)
  final IconData? icon;
  // La función que se ejecutará al pulsar el botón
  final VoidCallback onTap;
  // Un valor de 'flex' para que las teclas de ENTER/BORRAR puedan ser más anchas
  final int flex;

  const KeyButton({
    super.key,
    required this.letter,
    required this.onTap,
    this.icon,
    this.flex = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Material(
          color: Colors.grey.shade800,
          borderRadius: BorderRadius.circular(4),
          child: InkWell(
            onTap: onTap,
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