// En lib/presentation/screens/audio_settings_screen.dart
import 'package:flutter/material.dart';
import '../../core/services/sound_manager.dart';

class AudioSettingsScreen extends StatefulWidget {
  const AudioSettingsScreen({super.key});

  @override
  State<AudioSettingsScreen> createState() => _AudioSettingsScreenState();
}

class _AudioSettingsScreenState extends State<AudioSettingsScreen> {
  // Obtenemos la instancia de nuestro Singleton
  final SoundManager _soundManager = SoundManager.instance;
  late double _currentVolume;

  @override
  void initState() {
    super.initState();
    _currentVolume = _soundManager.currentVolume;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajustes de Sonido'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                const Icon(Icons.volume_up),
                Expanded(
                  child: Slider(
                    value: _currentVolume,
                    onChanged: (newVolume) {
                      setState(() {
                        _currentVolume = newVolume;
                      });
                      _soundManager.setVolume(newVolume);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}