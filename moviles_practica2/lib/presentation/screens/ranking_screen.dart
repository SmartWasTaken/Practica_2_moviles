import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/constants/enums.dart';
import '../../core/models/score.dart';
import '../../data/repositories/game_repository.dart';

class RankingScreen extends StatefulWidget {
  const RankingScreen({super.key});

  @override
  State<RankingScreen> createState() => _RankingScreenState();
}

class _RankingScreenState extends State<RankingScreen> {
  final GameRepository _gameRepository = GameRepository();
  late Future<List<Score>> _scoresFuture;

  @override
  void initState() {
    super.initState();
    _scoresFuture = _gameRepository.getRanking();
  }

  Widget _buildGameModeChip(GameMode gameMode) {
    // ... (esta función no cambia)
    Color chipColor;
    String modeName;
    switch (gameMode) {
      case GameMode.normal:
        chipColor = Colors.blue.shade800;
        modeName = 'Normal';
        break;
      case GameMode.timeTrial:
        chipColor = Colors.orange.shade800;
        modeName = 'Contrarreloj';
        break;
      case GameMode.emojis:
        chipColor = Colors.purple.shade800;
        modeName = 'Emojis';
        break;
    }
    return Chip(
      label: Text(modeName, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      backgroundColor: chipColor,
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
      labelPadding: const EdgeInsets.symmetric(horizontal: 4.0),
      visualDensity: VisualDensity.compact,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ranking de Puntuaciones'),
      ),
      body: FutureBuilder<List<Score>>(
        future: _scoresFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error al cargar las puntuaciones: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'Aún no hay puntuaciones.\n¡Juega una partida para ser el primero!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
            );
          }

          final scores = snapshot.data!;
          return ListView.builder(
            itemCount: scores.length,
            itemBuilder: (context, index) {
              final score = scores[index];
              final formattedDate = DateFormat('dd/MM/yyyy').format(score.date);
              final formattedTime = DateFormat('HH:mm').format(score.date);

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      children: [
                        CircleAvatar(child: Text('${index + 1}')),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // --- EL CAMBIO CLAVE: Reemplazamos Row por Wrap ---
                              Wrap(
                                spacing: 8.0, // Espacio horizontal entre los elementos
                                runSpacing: 4.0, // Espacio vertical si se van a una nueva línea
                                crossAxisAlignment: WrapCrossAlignment.center, // Alinea los elementos verticalmente
                                children: [
                                  Text('${score.scoreValue} Puntos', style: Theme.of(context).textTheme.titleMedium),
                                  _buildGameModeChip(score.gameMode),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Dificultad: ${score.difficulty.name} - Intentos: ${score.attempts} - Tiempo: ${score.timeInSeconds}s',
                                style: Theme.of(context).textTheme.bodySmall,
                                softWrap: true,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(formattedDate, style: Theme.of(context).textTheme.bodySmall),
                            Text(formattedTime, style: Theme.of(context).textTheme.bodySmall),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}