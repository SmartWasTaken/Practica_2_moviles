import 'package:equatable/equatable.dart';

class EmojiPuzzle extends Equatable {
  final String name;
  final String theme;
  final List<String> emojis;

  const EmojiPuzzle({
    required this.name,
    required this.theme,
    required this.emojis,
  });

  factory EmojiPuzzle.fromJson(Map<String, dynamic> json) {
    return EmojiPuzzle(
      name: json['name'] as String,
      theme: json['theme'] as String,
      emojis: List<String>.from(json['emojis'] as List),
    );
  }

  @override
  List<Object?> get props => [name, theme, emojis];
}