import 'package:flutter/material.dart';
import '../../data/providers/word_provider.dart';
import '../../data/repositories/preferences_repository.dart';
import '../routes/custom_page_route.dart';
import 'audio_settings_screen.dart';

class SettingsScreen extends StatefulWidget {
  final bool isInGameMode;

  const SettingsScreen({super.key, this.isInGameMode = false});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final PreferencesRepository _prefsRepository = PreferencesRepository();
  Difficulty _selectedDifficulty = Difficulty.medio;

  @override
  void initState() {
    super.initState();
    _loadDifficulty();
  }

  void _loadDifficulty() async {
    final savedDifficulty = await _prefsRepository.getDifficulty();
    setState(() {
      _selectedDifficulty = savedDifficulty;
    });
  }

  void _onDifficultyChanged(Difficulty? value) {
    if (value != null) {
      setState(() {
        _selectedDifficulty = value;
      });
      if (!widget.isInGameMode) {
        _prefsRepository.saveDifficulty(value);
      }
    }
  }

  void _applyChanges() {
    showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Confirmar Cambio'),
        content: const Text('Estás seguro de que quieres aplicar el nivel de dificultad, esto hará que pierdas el progreso de la partida.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              _prefsRepository.saveDifficulty(_selectedDifficulty);
              Navigator.of(dialogContext).pop(true);
            },
            child: const Text('Aceptar'),
          ),
        ],
      ),
    ).then((confirmed) {
      if (confirmed ?? false) {
        Navigator.of(context).pop(_selectedDifficulty);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajustes'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // --- SECCIÓN DE SONIDO ---
          Text('Sonido', style: Theme.of(context).textTheme.titleLarge),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.volume_up),
            title: const Text('Ajustes de Sonido'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.of(context).push(
                FadePageRoute(page: const AudioSettingsScreen()),
              );
            },
          ),
          const SizedBox(height: 24),

          // --- SECCIÓN DE DIFICULTAD ---
          Text('Dificultad del Juego', style: Theme.of(context).textTheme.titleLarge),
          const Divider(),
          RadioListTile<Difficulty>(title: const Text('Fácil (4 letras)'), value: Difficulty.facil, groupValue: _selectedDifficulty, onChanged: _onDifficultyChanged),
          RadioListTile<Difficulty>(title: const Text('Medio (5 letras)'), value: Difficulty.medio, groupValue: _selectedDifficulty, onChanged: _onDifficultyChanged),
          RadioListTile<Difficulty>(title: const Text('Difícil (6 letras)'), value: Difficulty.dificil, groupValue: _selectedDifficulty, onChanged: _onDifficultyChanged),
          const SizedBox(height: 24),

          // El botón "Aplicar" o "Volver"
          if (widget.isInGameMode)
            ElevatedButton(
              onPressed: _applyChanges,
              child: const Text('Aplicar'),
            )
          else
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Volver al Menú'),
            ),
        ],
      ),
    );
  }
}