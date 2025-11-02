import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/game_repository.dart';
import '../../data/repositories/preferences_repository.dart';
import '../bloc/game/game_bloc.dart';
import '../bloc/game/game_event.dart';
import '../routes/custom_page_route.dart'; // <-- Importamos la nueva ruta
import 'game_screen.dart';
import 'ranking_screen.dart';
import 'settings_screen.dart';

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ... (sin cambios aquí)
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
            ElevatedButton(
              // ... (estilo sin cambios)
              onPressed: () async {
                final difficulty = await preferencesRepository.getDifficulty();
                if (context.mounted) {
                  Navigator.of(context).push(
                    // --- CAMBIO AQUÍ ---
                    FadePageRoute(
                      page: BlocProvider(
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
            ElevatedButton(
              // ... (estilo sin cambios)
              onPressed: () {
                Navigator.of(context).push(
                  // --- CAMBIO AQUÍ ---
                  FadePageRoute(page: const RankingScreen()),
                );
              },
              child: const Text('Ranking'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              // ... (estilo sin cambios)
              onPressed: () {
                Navigator.of(context).push(
                  // --- CAMBIO AQUÍ ---
                  FadePageRoute(page: const SettingsScreen()),
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