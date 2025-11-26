import 'package:flutter/material.dart';
import '../../core/services/sound_manager.dart';

class CustomImageButton extends StatefulWidget {
  final String defaultImagePath;
  final String pressedImagePath;
  final VoidCallback onPressed;
  final double width;
  final double height;

  const CustomImageButton({
    super.key,
    required this.defaultImagePath,
    required this.pressedImagePath,
    required this.onPressed,
    this.width = 200,
    this.height = 60,
  });

  @override
  State<CustomImageButton> createState() => _CustomImageButtonState();
}

class _CustomImageButtonState extends State<CustomImageButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 50),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          _isPressed = true;
        });
        _controller.forward();
      },
      onTapUp: (_) {
        setState(() {
          _isPressed = false;
        });
        _controller.reverse();
        SoundManager.instance.playSfx('ui_click.wav');
        widget.onPressed();
      },
      onTapCancel: () {
        setState(() {
          _isPressed = false;
        });
        _controller.reverse();
      },
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Image.asset(
          _isPressed ? widget.pressedImagePath : widget.defaultImagePath,
          width: widget.width,
          height: widget.height,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}