import 'dart:io';
import 'dart:convert';
import 'dart:math';

void main() {
  print("Generando JSON de números...");

  final data = {
    'facil': _generateNumbers(4),
    'medio': _generateNumbers(5),
    'dificil': _generateNumbers(6),
  };

  final file = File('../assets/numbers.json');
  file.writeAsStringSync(json.encode(data));

  print("¡Éxito!");
  print("Archivo 'numbers.json' generado en la carpeta 'assets'.");
  print("Contiene:");
  print("- ${data['facil']!.length} números de 4 dígitos.");
  print("- ${data['medio']!.length} números de 5 dígitos.");
  print("- ${data['dificil']!.length} números de 6 dígitos.");
}

List<String> _generateNumbers(int digits) {
  final numbers = <String>[];
  final max = pow(10, digits);

  for (int i = 0; i < max; i++) {
    numbers.add(i.toString().padLeft(digits, '0'));
  }
  return numbers;
}