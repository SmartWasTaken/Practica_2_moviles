import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/constants/enums.dart';
import '../../core/services/sound_manager.dart';
import '../../data/providers/word_provider.dart';
import '../../data/repositories/preferences_repository.dart';
import '../bloc/settings/settings_bloc.dart';
import '../bloc/settings/settings_event.dart';
import '../bloc/settings/settings_state.dart';
import '../routes/custom_page_route.dart';
import '../widgets/custom_image_button.dart';
import '../widgets/game_background.dart';
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
    SoundManager.instance.playSfx('ui_click.wav');
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
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('Ajustes'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: GameBackground(
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            Text('Sonido', style: Theme.of(context).textTheme.titleLarge),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.volume_up),
              title: const Text('Ajustes de Sonido'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                SoundManager.instance.playSfx('ui_click.wav');
                Navigator.of(context).push(
                  FadePageRoute(page: const AudioSettingsScreen()),
                );
              },
            ),

            const SizedBox(height: 24),
            Text('Accesibilidad', style: Theme.of(context).textTheme.titleLarge),
            const Divider(),
            BlocBuilder<SettingsBloc, SettingsState>(
              builder: (context, state) {
                return Column(
                  children: [
                    SwitchListTile(
                      title: const Text('Modo Alto Contraste'),
                      subtitle: const Text('Colores naranja/azul.'),
                      value: state.isHighContrast,
                      activeColor: Colors.orange,
                      onChanged: (bool value) {
                        SoundManager.instance.playSfx('ui_click.wav');
                        context.read<SettingsBloc>().add(ToggleHighContrast(value));
                      },
                    ),
                    SwitchListTile(
                      title: const Text('Vibración'),
                      subtitle: const Text('Respuesta háptica al pulsar.'),
                      value: state.isHapticsEnabled,
                      activeColor: Colors.green,
                      onChanged: (bool value) {
                        SoundManager.instance.playSfx('ui_click.wav');
                        context.read<SettingsBloc>().add(ToggleHaptics(value));
                      },
                    ),
                  ],
                );
              },
            ),

            const SizedBox(height: 24),
            Text('Dificultad del Juego', style: Theme.of(context).textTheme.titleLarge),
            const Divider(),
            RadioListTile<Difficulty>(
                title: const Text('Fácil'),
                value: Difficulty.facil,
                groupValue: _selectedDifficulty,
                onChanged: _onDifficultyChanged),
            RadioListTile<Difficulty>(
                title: const Text('Medio'),
                value: Difficulty.medio,
                groupValue: _selectedDifficulty,
                onChanged: _onDifficultyChanged),
            RadioListTile<Difficulty>(
                title: const Text('Difícil'),
                value: Difficulty.dificil,
                groupValue: _selectedDifficulty,
                onChanged: _onDifficultyChanged),
            const SizedBox(height: 24),
            if (widget.isInGameMode)
              ElevatedButton(
                onPressed: _applyChanges,
                child: const Text('Aplicar'),
              )
            else
              Center(
                child: CustomImageButton(
                  defaultImagePath: 'assets/images/btn_volver_default.png',
                  pressedImagePath: 'assets/images/btn_volver_pressed.png',
                  width: 110,
                  height: 70,
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}