import 'package:shared_preferences/shared_preferences.dart';
import '../providers/word_provider.dart'; // Necesitamos nuestro enum Difficulty

class PreferencesRepository {
  // Esta es la 'clave' bajo la cual guardaremos la dificultad en el dispositivo.
  static const _difficultyKey = 'game_difficulty';

  // Método para guardar la dificultad seleccionada por el usuario.
  Future<void> saveDifficulty(Difficulty difficulty) async {
    // Obtenemos la instancia del almacenamiento local.
    final prefs = await SharedPreferences.getInstance();
    // Guardamos la dificultad como un String (ej: "medio").
    await prefs.setString(_difficultyKey, difficulty.toString().split('.').last);
  }

  // Método para cargar la dificultad guardada.
  Future<Difficulty> getDifficulty() async {
    final prefs = await SharedPreferences.getInstance();
    // Leemos el String guardado bajo nuestra clave.
    final savedDifficulty = prefs.getString(_difficultyKey);

    // Si no hay nada guardado (primera vez que se abre la app),
    // devolvemos 'medio' como valor por defecto.
    if (savedDifficulty == null) {
      return Difficulty.medio;
    }

    // Convertimos el String guardado ("facil", "medio", "dificil") de vuelta a nuestro enum.
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