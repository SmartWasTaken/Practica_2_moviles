// En lib/data/repositories/game_repository.dart

// --- AÑADE ESTAS DOS IMPORTACIONES ---
import '../../core/models/score.dart';
import '../providers/database_provider.dart';
import '../providers/word_provider.dart';

class GameRepository {
  final WordProvider _wordProvider;
  // Esta línea ahora funcionará porque hemos importado DatabaseProvider
  final DatabaseProvider _dbProvider = DatabaseProvider.instance;

  GameRepository({WordProvider? wordProvider})
      : _wordProvider = wordProvider ?? WordProvider();

  Future<String> getWord(Difficulty difficulty) async {
    return _wordProvider.getWord(difficulty);
  }

  // Este método ahora funcionará porque hemos importado Score
  Future<void> saveScore(Score score) async {
    await _dbProvider.insertScore(score);
  }

  Future<List<Score>> getRanking() async {
    return _dbProvider.getScores();
  }
}