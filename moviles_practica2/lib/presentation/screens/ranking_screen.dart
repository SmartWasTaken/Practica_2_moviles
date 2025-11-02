import 'package:flutter/material.dart';
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
              return ListTile(
                leading: CircleAvatar(
                  child: Text('${index + 1}'),
                ),
                title: Text('${score.scoreValue} Puntos'),
                subtitle: Text(
                    'Dificultad: ${score.difficulty.name} - Intentos: ${score.attempts} - Tiempo: ${score.timeInSeconds}s'
                ),
                trailing: Text(
                  '${score.date.day}/${score.date.month}/${score.date.year}',
                  style: const TextStyle(fontSize: 12),
                ),
              );
            },
          );
        },
      ),
    );
  }
}