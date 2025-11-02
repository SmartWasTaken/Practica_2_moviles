import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart';
import '../../core/constants/enums.dart';

class WordProvider {
  Future<Map<String, List<dynamic>>> _loadWords() async {
    final String jsonString = await rootBundle.loadString('assets/words.json');
    final Map<String, dynamic> jsonMap = json.decode(jsonString);

    return jsonMap.map((key, value) {
      return MapEntry(key, List<dynamic>.from(value));
    });
  }

  Future<String> getWord(Difficulty difficulty) async {
    final wordsByDifficulty = await _loadWords();

    final difficultyKey = difficulty.toString().split('.').last;

    final List<dynamic>? words = wordsByDifficulty[difficultyKey];

    if (words == null || words.isEmpty) {
      // Si algo va mal, lanzamos un error claro.
      throw Exception('No words found for difficulty: $difficultyKey');
    }

    final random = Random();
    return words[random.nextInt(words.length)].toString().toUpperCase();
  }
}