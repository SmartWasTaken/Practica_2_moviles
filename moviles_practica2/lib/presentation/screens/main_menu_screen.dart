import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/game_repository.dart';
import '../../data/repositories/preferences_repository.dart';
import '../bloc/game/game_bloc.dart';
import '../bloc/game/game_event.dart';
import 'game_screen.dart';
import 'ranking_screen.dart'; // <-- AÑADE ESTA IMPORTACIÓN
import 'settings_screen.dart';

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final preferencesRepository = PreferencesRepository();
    final gameRepository = GameRepository();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Wordle - Menú Principal'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Botón Jugar (sin cambios)
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                textStyle: const TextStyle(fontSize: 20),
              ),
              onPressed: () async {
                final difficulty = await preferencesRepository.getDifficulty();
                if (context.mounted) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => BlocProvider(
                        create: (context) => GameBloc(gameRepository: gameRepository)
                          ..add(StartNewGame(difficulty: difficulty)),
                        child: const GameScreen(),
                      ),
                    ),
                  );
                }
              },
              child: const Text('Jugar'),
            ),
            const SizedBox(height: 20),

            // --- AÑADE ESTE NUEVO BOTÓN ---
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                textStyle: const TextStyle(fontSize: 20),
              ),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const RankingScreen(),
                  ),
                );
              },
              child: const Text('Ranking'),
            ),
            const SizedBox(height: 20),

            // Botón Ajustes (sin cambios)
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                textStyle: const TextStyle(fontSize: 20),
              ),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const SettingsScreen(),
                  ),
                );
              },
              child: const Text('Ajustes'),
            ),
          ],
        ),
      ),
    );
  }
}