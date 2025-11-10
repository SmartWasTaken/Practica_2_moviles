import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart';
import '../../core/constants/enums.dart';

class NumberProvider {
  static Map<String, List<dynamic>>? _cachedNumbers;

  Future<Map<String, List<dynamic>>> _loadNumbers() async {
    if (_cachedNumbers != null) {
      return _cachedNumbers!;
    }

    final String jsonString = await rootBundle.loadString('assets/numbers.json');
    final Map<String, dynamic> jsonMap = json.decode(jsonString);
    final typedMap = jsonMap.map((key, value) {
      return MapEntry(key, List<dynamic>.from(value));
    });

    _cachedNumbers = typedMap;
    return typedMap;
  }

  Future<String> getNumber(Difficulty difficulty) async {
    final numbersByDifficulty = await _loadNumbers(); // Ahora es súper rápido
    final difficultyKey = difficulty.toString().split('.').last;
    final List<dynamic>? numbers = numbersByDifficulty[difficultyKey];

    if (numbers == null || numbers.isEmpty) {
      throw Exception('No numbers found for difficulty: $difficultyKey');
    }

    final random = Random();
    return numbers[random.nextInt(numbers.length)].toString();
  }
}