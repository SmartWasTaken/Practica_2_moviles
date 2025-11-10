import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart';
import '../../core/constants/enums.dart';

class WordProvider {
  static Map<String, List<dynamic>>? _cachedWords;

  Future<Map<String, List<dynamic>>> _loadWords() async {
    if (_cachedWords != null) {
      return _cachedWords!;
    }

    final String jsonString = await rootBundle.loadString('assets/words.json');
    final Map<String, dynamic> jsonMap = json.decode(jsonString);
    final typedMap = jsonMap.map((key, value) {
      return MapEntry(key, List<dynamic>.from(value));
    });

    _cachedWords = typedMap;
    return typedMap;
  }

  Future<String> getWord(Difficulty difficulty) async {
    final wordsByDifficulty = await _loadWords(); // Ahora es casi instantáneo después de la 1ª vez
    final difficultyKey = difficulty.toString().split('.').last;
    final List<dynamic>? words = wordsByDifficulty[difficultyKey];

    if (words == null || words.isEmpty) {
      throw Exception('No words found for difficulty: $difficultyKey');
    }

    final random = Random();
    return words[random.nextInt(words.length)].toString().toUpperCase();
  }
}