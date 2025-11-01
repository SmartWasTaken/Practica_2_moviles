import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart';

// Definimos un enum para la Dificultad.
// Es más seguro y limpio que usar Strings como "facil", "medio", etc.
// porque evita errores de tipeo.
enum Difficulty { facil, medio, dificil }

class WordProvider {
  // Un método privado para cargar y decodificar el archivo JSON.
  // Es asíncrono (devuelve un Future) porque leer un archivo toma tiempo.
  Future<Map<String, List<dynamic>>> _loadWords() async {
    final String jsonString = await rootBundle.loadString('assets/words.json');
    final Map<String, dynamic> jsonMap = json.decode(jsonString);

    // ---- ESTA ES LA LÍNEA QUE CAMBIA ----
    // Reconstruimos el mapa, convirtiendo explícitamente cada valor a una List<dynamic>.
    // Esto satisface la promesa de tipo que hicimos en la firma de la función.
    return jsonMap.map((key, value) {
      return MapEntry(key, List<dynamic>.from(value));
    });
  }

  // El único método público de nuestra clase.
  // Esta es la función que el resto de la app usará.
  Future<String> getWord(Difficulty difficulty) async {
    final wordsByDifficulty = await _loadWords();

    // Convertimos el valor del enum (ej: Difficulty.facil) a un String ("facil").
    final difficultyKey = difficulty.toString().split('.').last;

    // Obtenemos la lista de palabras para la dificultad seleccionada.
    final List<dynamic>? words = wordsByDifficulty[difficultyKey];

    // Una comprobación de seguridad por si el JSON está mal formado o no hay palabras.
    if (words == null || words.isEmpty) {
      // Si algo va mal, lanzamos un error claro.
      throw Exception('No words found for difficulty: $difficultyKey');
    }

    // Creamos una instancia de Random para elegir una palabra al azar.
    final random = Random();
    // Elegimos un índice aleatorio de la lista y devolvemos la palabra en esa posición.
    // La convertimos a mayúsculas para asegurar consistencia.
    return words[random.nextInt(words.length)].toString().toUpperCase();
  }
}