import '../../core/models/score.dart';
import '../providers/database_provider.dart';
import '../providers/word_provider.dart';
import '../providers/number_provider.dart';
import '../../core/constants/enums.dart';
import '../providers/emoji_provider.dart';
import '../../core/models/emoji_puzzle.dart';

class GameRepository {
  final WordProvider _wordProvider;
  final NumberProvider _numberProvider;
  final EmojiProvider _emojiProvider;
  final DatabaseProvider _dbProvider = DatabaseProvider.instance;
  GameRepository({
    WordProvider? wordProvider,
    NumberProvider? numberProvider,
    EmojiProvider? emojiProvider,
  })  : _wordProvider = wordProvider ?? WordProvider(),
        _numberProvider = numberProvider ?? NumberProvider(),
        _emojiProvider = emojiProvider ?? EmojiProvider();
  Future<String> getWord(Difficulty difficulty) async {
    return _wordProvider.getWord(difficulty);
  }
  Future<String> getNumber(Difficulty difficulty) async {
    return _numberProvider.getNumber(difficulty);
  }
  Future<void> saveScore(Score score) async {
    await _dbProvider.insertScore(score);
  }
  Future<List<Score>> getRanking() async {
    return _dbProvider.getScores();
  }
  Future<EmojiPuzzle> getEmojiPuzzle(Difficulty difficulty) async {
    return _emojiProvider.getEmojiPuzzle(difficulty);
  }
}