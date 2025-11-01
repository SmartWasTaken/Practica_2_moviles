import 'package:flutter/material.dart';
import '../../core/models/score.dart';
import '../../data/repositories/game_repository.dart';

class RankingScreen extends StatefulWidget {
  const RankingScreen({super.key});

  @override
  State<RankingScreen> createState() => _RankingScreenState();
}

class _RankingScreenState extends State<RankingScreen> {
  // Declaramos el repositorio para poder usarlo.
  final GameRepository _gameRepository = GameRepository();
  // Esta variable guardará el 'Future' que obtiene las puntuaciones.
  late Future<List<Score>> _scoresFuture;

  @override
  void initState() {
    super.initState();
    // En cuanto la pantalla se crea, pedimos la lista de puntuaciones.
    // Esto inicia la operación asíncrona.
    _scoresFuture = _gameRepository.getRanking();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ranking de Puntuaciones'),
      ),
      // FutureBuilder es el widget clave aquí.
      body: FutureBuilder<List<Score>>(
        // 1. Le decimos qué Future debe 'observar'.
        future: _scoresFuture,
        // 2. El 'builder' se ejecuta cada vez que el estado del Future cambia.
        builder: (context, snapshot) {
          // CASO 1: El Future todavía está cargando.
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // CASO 2: El Future terminó con un error.
          if (snapshot.hasError) {
            return Center(child: Text('Error al cargar las puntuaciones: ${snapshot.error}'));
          }

          // CASO 3: El Future terminó con éxito, pero no hay datos.
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'Aún no hay puntuaciones.\n¡Juega una partida para ser el primero!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
            );
          }

          // CASO 4: ¡Tenemos datos! Los mostramos en una lista.
          final scores = snapshot.data!;
          return ListView.builder(
            itemCount: scores.length,
            itemBuilder: (context, index) {
              final score = scores[index];
              // Usamos un ListTile para un formato de lista limpio y estándar.
              return ListTile(
                leading: CircleAvatar(
                  child: Text('${index + 1}'), // Posición en el ranking
                ),
                title: Text('${score.scoreValue} Puntos'),
                subtitle: Text(
                    'Dificultad: ${score.difficulty.name} - Intentos: ${score.attempts} - Tiempo: ${score.timeInSeconds}s'
                ),
                trailing: Text(
                  // Formateamos la fecha para que sea más legible
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