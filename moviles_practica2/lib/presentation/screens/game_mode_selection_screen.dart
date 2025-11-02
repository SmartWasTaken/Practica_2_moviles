import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/constants/enums.dart';
import '../../data/repositories/game_repository.dart';
import '../../data/repositories/preferences_repository.dart';
import '../bloc/game/game_bloc.dart';
import '../bloc/game/game_event.dart';
import '../routes/custom_page_route.dart';
import 'game_screen.dart';

class GameModeSelectionScreen extends StatefulWidget {
  const GameModeSelectionScreen({super.key});

  @override
  State<GameModeSelectionScreen> createState() => _GameModeSelectionScreenState();
}

class _GameModeSelectionScreenState extends State<GameModeSelectionScreen> {
  // Variable para recordar la duración seleccionada para el modo Contrarreloj.
  Duration _selectedTime = const Duration(minutes: 1);

  // Función de ayuda para no repetir código. Lanza el juego con los parámetros correctos.
  void _startGame(BuildContext context, GameMode mode, {Duration? timeLimit}) async {
    // Necesitamos el repositorio para obtener la dificultad guardada.
    final preferencesRepository = PreferencesRepository();
    final difficulty = await preferencesRepository.getDifficulty();

    if (mounted) { // Comprobación de seguridad después de una operación asíncrona
      Navigator.of(context).push(
        FadePageRoute(
          page: BlocProvider(
            // El GameBloc se crea justo antes de entrar a la pantalla de juego.
            create: (context) => GameBloc(gameRepository: GameRepository())
              ..add(StartNewGame(
                difficulty: difficulty,
                gameMode: mode,
                timeLimit: timeLimit,
              )),
            child: const GameScreen(),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Elige un Modo de Juego'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // --- TARJETA PARA EL MODO NORMAL ---
          Card(
            child: ListTile(
              leading: const Icon(Icons.play_circle_outline, size: 40),
              title: const Text('Normal', style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: const Text('Adivina la palabra sin límite de tiempo. ¡El cronómetro sube!'),
              onTap: () => _startGame(context, GameMode.normal),
            ),
          ),
          const SizedBox(height: 16),

          // --- TARJETA PARA EL MODO CONTRARRELOJ ---
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(Icons.timer_outlined, size: 40),
                    title: Text('Contrarreloj', style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('Adivina la palabra antes de que se acabe el tiempo.'),
                  ),
                  // SegmentedButton es un widget moderno perfecto para este tipo de selección.
                  SegmentedButton<Duration>(
                    segments: const [
                      ButtonSegment(value: Duration(minutes: 1), label: Text('1 min')),
                      ButtonSegment(value: Duration(minutes: 2), label: Text('2 min')),
                      ButtonSegment(value: Duration(minutes: 3), label: Text('3 min')),
                    ],
                    selected: {_selectedTime},
                    onSelectionChanged: (newSelection) {
                      setState(() {
                        _selectedTime = newSelection.first;
                      });
                    },
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () => _startGame(context, GameMode.timeTrial, timeLimit: _selectedTime),
                    child: const Text('Jugar Contrarreloj'),
                  ),
                ],
              ),
            ),
          ),

          // --- TARJETA PARA EL MODO EMOJIS (Deshabilitado por ahora) ---
          Card(
            color: Theme.of(context).colorScheme.surface.withOpacity(0.5), // Color atenuado
            child: ListTile(
              leading: Icon(Icons.emoji_emotions_outlined, size: 40, color: Colors.grey.shade600),
              title: Text('Emojis', style: TextStyle(color: Colors.grey.shade600, fontWeight: FontWeight.bold)),
              subtitle: Text('Próximamente...', style: TextStyle(color: Colors.grey.shade600)),
              onTap: null, // onTap: null deshabilita el ListTile
            ),
          ),
        ],
      ),
    );
  }
}