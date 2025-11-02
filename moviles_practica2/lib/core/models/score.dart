import '../constants/enums.dart';
import '../../data/providers/word_provider.dart';

class Score {
  final int? id;
  final int scoreValue;
  final Difficulty difficulty;
  final GameMode gameMode;
  final int timeInSeconds;
  final int attempts;
  final DateTime date;

  Score({
    this.id,
    required this.scoreValue,
    required this.difficulty,
    required this.gameMode,
    required this.timeInSeconds,
    required this.attempts,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'scoreValue': scoreValue,
      'difficulty': difficulty.toString().split('.').last,
      'gameMode': gameMode.toString().split('.').last,
      'timeInSeconds': timeInSeconds,
      'attempts': attempts,
      'date': date.toIso8601String(),
    };
  }

  factory Score.fromMap(Map<String, dynamic> map) {
    return Score(
      id: map['id'],
      scoreValue: map['scoreValue'],
      difficulty: Difficulty.values.firstWhere(
              (e) => e.toString().split('.').last == map['difficulty'],
          orElse: () => Difficulty.medio),
      gameMode: GameMode.values.firstWhere(
            (e) => e.toString().split('.').last == map['gameMode'],
        orElse: () => GameMode.normal,
      ),
      timeInSeconds: map['timeInSeconds'],
      attempts: map['attempts'],
      date: DateTime.parse(map['date']),
    );
  }
}