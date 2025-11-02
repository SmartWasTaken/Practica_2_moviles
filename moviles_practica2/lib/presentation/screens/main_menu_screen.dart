import 'package:flutter/material.dart';
import '../routes/custom_page_route.dart';
import 'game_mode_selection_screen.dart';
import 'ranking_screen.dart';
import 'settings_screen.dart';

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Definimos un estilo de botón común para no repetir código.
    final buttonStyle = ElevatedButton.styleFrom(
      padding: const EdgeInsets.symmetric(vertical: 20), // El padding horizontal ya no es necesario
      textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Wordle - Menú Principal'),
        centerTitle: true,
      ),
      body: Center(
        child: SizedBox(
          width: 250,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ElevatedButton(
                style: buttonStyle,
                onPressed: () {
                  Navigator.of(context).push(
                    FadePageRoute(page: const GameModeSelectionScreen()),
                  );
                },
                child: const Text('Jugar'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: buttonStyle,
                onPressed: () {
                  Navigator.of(context).push(
                    FadePageRoute(page: const RankingScreen()),
                  );
                },
                child: const Text('Ranking'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: buttonStyle,
                onPressed: () {
                  Navigator.of(context).push(
                    FadePageRoute(page: const SettingsScreen()),
                  );
                },
                child: const Text('Ajustes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}