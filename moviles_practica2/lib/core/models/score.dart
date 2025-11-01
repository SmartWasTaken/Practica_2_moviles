import '../../data/providers/word_provider.dart';

class Score {
  final int? id; // El ID de la base de datos será opcional
  final int scoreValue;
  final Difficulty difficulty;
  final int timeInSeconds;
  final int attempts;
  final DateTime date;

  Score({
    this.id,
    required this.scoreValue,
    required this.difficulty,
    required this.timeInSeconds,
    required this.attempts,
    required this.date,
  });

  // Método para convertir nuestro objeto Score a un Map,
  // que es el formato que SQLite necesita para guardar datos.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'scoreValue': scoreValue,
      'difficulty': difficulty.toString().split('.').last, // Guardamos "medio"
      'timeInSeconds': timeInSeconds,
      'attempts': attempts,
      'date': date.toIso8601String(), // Guardamos la fecha como texto
    };
  }

  // Método para crear un objeto Score a partir de un Map
  // que leemos de la base de datos.
  factory Score.fromMap(Map<String, dynamic> map) {
    return Score(
      id: map['id'],
      scoreValue: map['scoreValue'],
      difficulty: Difficulty.values.firstWhere(
            (e) => e.toString().split('.').last == map['difficulty'],
        orElse: () => Difficulty.medio, // Valor por defecto si hay un error
      ),
      timeInSeconds: map['timeInSeconds'],
      attempts: map['attempts'],
      date: DateTime.parse(map['date']),
    );
  }
}