import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart';
import '../../core/constants/enums.dart';
import '../../core/models/emoji_puzzle.dart';

class EmojiProvider {
  static Map<String, List<EmojiPuzzle>>? _cachedPuzzles;

  Future<Map<String, List<EmojiPuzzle>>> _loadPuzzles() async {
    if (_cachedPuzzles != null) {
      return _cachedPuzzles!;
    }

    final String jsonString = await rootBundle.loadString('assets/emojis.json');
    final Map<String, dynamic> jsonMap = json.decode(jsonString);

    final Map<String, List<EmojiPuzzle>> parsedMap = {};

    jsonMap.forEach((difficultyKey, puzzleListJson) {
      final List<EmojiPuzzle> puzzles = (puzzleListJson as List)
          .map((puzzleJson) => EmojiPuzzle.fromJson(puzzleJson as Map<String, dynamic>))
          .toList();
      parsedMap[difficultyKey] = puzzles;
    });

    _cachedPuzzles = parsedMap;
    return parsedMap;
  }

  Future<EmojiPuzzle> getEmojiPuzzle(Difficulty difficulty) async {
    final puzzlesByDifficulty = await _loadPuzzles();
    final difficultyKey = difficulty.toString().split('.').last;
    final List<EmojiPuzzle>? puzzles = puzzlesByDifficulty[difficultyKey];

    if (puzzles == null || puzzles.isEmpty) {
      throw Exception('No emoji puzzles found for difficulty: $difficultyKey');
    }

    final random = Random();
    return puzzles[random.nextInt(puzzles.length)];
  }
}