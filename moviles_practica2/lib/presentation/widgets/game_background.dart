import 'package:flutter/material.dart';

class GameBackground extends StatelessWidget {
  final Widget child;
  final String imagePath;

  const GameBackground({
    super.key,
    required this.child,
    this.imagePath = 'assets/images/background.png',
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            imagePath,
            fit: BoxFit.cover,
          ),
        ),
        SafeArea(
          child: child,
        ),
      ],
    );
  }
}