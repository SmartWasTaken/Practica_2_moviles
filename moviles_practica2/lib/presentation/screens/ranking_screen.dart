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

  GameMode? _selectedFilter;

  @override
  void initState() {
    super.initState();
    _scoresFuture = _gameRepository.getRanking();
  }

  Widget _buildGameModeChip(GameMode gameMode) {
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
      case GameMode.numbers:
        chipColor = Colors.cyan.shade800;
        modeName = 'Números';
        break;
      case GameMode.competitive:
        chipColor = Colors.red.shade800;
        modeName = 'Competitivo';
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

  Widget _buildFilterChips() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
      child: Wrap(
        spacing: 8.0,
        children: [
          FilterChip(
            label: const Text('Overall'),
            selected: _selectedFilter == null,
            onSelected: (bool selected) {
              setState(() {
                _selectedFilter = null;
              });
            },
          ),
          FilterChip(
            label: const Text('Normal'),
            selected: _selectedFilter == GameMode.normal,
            onSelected: (bool selected) {
              setState(() {
                _selectedFilter = GameMode.normal;
              });
            },
          ),
          FilterChip(
            label: const Text('Competitivo'),
            selected: _selectedFilter == GameMode.competitive,
            onSelected: (bool selected) {
              setState(() {
                _selectedFilter = GameMode.competitive;
              });
            },
          ),
          FilterChip(
            label: const Text('Contrarreloj'),
            selected: _selectedFilter == GameMode.timeTrial,
            onSelected: (bool selected) {
              setState(() {
                _selectedFilter = GameMode.timeTrial;
              });
            },
          ),
          FilterChip(
            label: const Text('Números'),
            selected: _selectedFilter == GameMode.numbers,
            onSelected: (bool selected) {
              setState(() {
                _selectedFilter = GameMode.numbers;
              });
            },
          ),
        ],
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ranking de Puntuaciones'),
      ),
      body: Column(
        children: [
          _buildFilterChips(),
          const Divider(height: 1),
          Expanded(
            child: FutureBuilder<List<Score>>(
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
                final allScores = snapshot.data!;
                final List<Score> filteredScores;
                if (_selectedFilter == null) {
                  filteredScores = allScores;
                } else {
                  filteredScores = allScores.where((score) => score.gameMode == _selectedFilter).toList();
                }
                if (filteredScores.isEmpty) {
                  return const Center(
                    child: Text(
                      'No hay puntuaciones para este modo de juego.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18),
                    ),
                  );
                }
                return ListView.builder(
                  itemCount: filteredScores.length,
                  itemBuilder: (context, index) {
                    final score = filteredScores[index];
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
                                    Wrap(
                                      spacing: 8.0,
                                      runSpacing: 4.0,
                                      crossAxisAlignment: WrapCrossAlignment.center,
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
          ),
        ],
      ),
    );
  }
}