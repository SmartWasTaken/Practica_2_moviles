import 'package:flutter/material.dart';
import '../../data/providers/word_provider.dart';
import '../../data/repositories/preferences_repository.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // El repositorio para guardar y cargar las preferencias.
  final PreferencesRepository _prefsRepository = PreferencesRepository();
  // Variable para guardar la dificultad seleccionada actualmente en la UI.
  // La inicializamos en 'medio' por si acaso.
  Difficulty _selectedDifficulty = Difficulty.medio;

  @override
  void initState() {
    super.initState();
    // 'initState' se llama una sola vez cuando el widget se crea.
    // Es el lugar perfecto para cargar los datos iniciales.
    _loadDifficulty();
  }

  // Método asíncrono para cargar la dificultad guardada en el dispositivo.
  void _loadDifficulty() async {
    final savedDifficulty = await _prefsRepository.getDifficulty();
    // Usamos 'setState' para notificar a Flutter que los datos han cambiado
    // y que necesita redibujar el widget con el valor correcto.
    setState(() {
      _selectedDifficulty = savedDifficulty;
    });
  }

  // Método para manejar el cambio de selección y guardar la nueva preferencia.
  void _onDifficultyChanged(Difficulty? value) {
    if (value != null) {
      setState(() {
        _selectedDifficulty = value;
      });
      // Guardamos la nueva selección de forma persistente.
      _prefsRepository.saveDifficulty(value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajustes'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Dificultad',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 10),
            // RadioListTile es un widget perfecto para este tipo de selección.
            RadioListTile<Difficulty>(
              title: const Text('Fácil (4 letras)'),
              value: Difficulty.facil,
              groupValue: _selectedDifficulty,
              onChanged: _onDifficultyChanged,
            ),
            RadioListTile<Difficulty>(
              title: const Text('Medio (5 letras)'),
              value: Difficulty.medio,
              groupValue: _selectedDifficulty,
              onChanged: _onDifficultyChanged,
            ),
            RadioListTile<Difficulty>(
              title: const Text('Difícil (6 letras)'),
              value: Difficulty.dificil,
              groupValue: _selectedDifficulty,
              onChanged: _onDifficultyChanged,
            ),
          ],
        ),
      ),
    );
  }
}