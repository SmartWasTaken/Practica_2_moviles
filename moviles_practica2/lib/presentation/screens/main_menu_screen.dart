import 'package:flutter/material.dart';
import '../routes/custom_page_route.dart';
import '../widgets/custom_image_button.dart';
import '../widgets/game_background.dart';
import 'game_mode_selection_screen.dart';
import 'ranking_screen.dart';
import 'settings_screen.dart';
import 'tutorial_screen.dart';

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GameBackground(
        imagePath: 'assets/images/background.png',
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Título o Logo del juego
              const Text(
                'PALAZLE',
                style: TextStyle(
                  fontSize: 60,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 5,
                  shadows: [
                    Shadow(
                      offset: Offset(3, 3),
                      blurRadius: 5.0,
                      color: Colors.black,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 50),

              // --- BOTÓN JUGAR ---
              CustomImageButton(
                defaultImagePath: 'assets/images/btn_jugar_default.png',
                pressedImagePath: 'assets/images/btn_jugar_pressed.png',
                width: 220,
                height: 70,
                onPressed: () {
                  Navigator.of(context).push(
                    FadePageRoute(page: const GameModeSelectionScreen()),
                  );
                },
              ),
              const SizedBox(height: 20),

              // --- BOTÓN RANKING ---
              CustomImageButton(
                defaultImagePath: 'assets/images/btn_ranking_default.png',
                pressedImagePath: 'assets/images/btn_ranking_pressed.png',
                width: 220,
                height: 70,
                onPressed: () {
                  Navigator.of(context).push(
                    FadePageRoute(page: const RankingScreen()),
                  );
                },
              ),
              const SizedBox(height: 20),

              CustomImageButton(
                defaultImagePath: 'assets/images/btn_ajustes_default.png',
                pressedImagePath: 'assets/images/btn_ajustes_pressed.png',
                width: 220,
                height: 70,
                onPressed: () {
                  Navigator.of(context).push(
                    FadePageRoute(page: const SettingsScreen()),
                  );
                },
              ),
              const SizedBox(height: 20),

              //CustomImageButton(
              //  defaultImagePath: 'assets/images/btn_tutorial_default.png',
              //  pressedImagePath: 'assets/images/btn_tutorial_pressed.png',
              //  width: 220,
              //  height: 70,
              //  onPressed: () {
              //    Navigator.of(context).push(
              //      FadePageRoute(page: const TutorialScreen()),
              //    );
              //  },
              //),
            ],
          ),
        ),
      ),
    );
  }
}