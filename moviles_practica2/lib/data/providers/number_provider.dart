import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart';
import '../../core/constants/enums.dart';

class NumberProvider {
  Future<Map<String, List<dynamic>>> _loadNumbers() async {
    final String jsonString = await rootBundle.loadString('assets/numbers.json');
    final Map<String, dynamic> jsonMap = json.decode(jsonString);
    return jsonMap.map((key, value) {
      return MapEntry(key, List<dynamic>.from(value));
    });
  }

  Future<String> getNumber(Difficulty difficulty) async {
    final numbersByDifficulty = await _loadNumbers();
    final difficultyKey = difficulty.toString().split('.').last;
    final List<dynamic>? numbers = numbersByDifficulty[difficultyKey];

    if (numbers == null || numbers.isEmpty) {
      throw Exception('No numbers found for difficulty: $difficultyKey');
    }

    final random = Random();
    return numbers[random.nextInt(numbers.length)].toString();
  }
}