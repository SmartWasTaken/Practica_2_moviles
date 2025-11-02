import 'package:shared_preferences/shared_preferences.dart';
import '../providers/word_provider.dart';

class PreferencesRepository {
  static const _difficultyKey = 'game_difficulty';

  // Método para guardar la dificultad seleccionada por el usuario.
  Future<void> saveDifficulty(Difficulty difficulty) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_difficultyKey, difficulty.toString().split('.').last);
  }

  // Método para cargar la dificultad guardada.
  Future<Difficulty> getDifficulty() async {
    final prefs = await SharedPreferences.getInstance();
    final savedDifficulty = prefs.getString(_difficultyKey);

    if (savedDifficulty == null) {
      return Difficulty.medio;
    }

    switch (savedDifficulty) {
      case 'facil':
        return Difficulty.facil;
      case 'dificil':
        return Difficulty.dificil;
      case 'medio':
      default:
        return Difficulty.medio;
    }
  }
}