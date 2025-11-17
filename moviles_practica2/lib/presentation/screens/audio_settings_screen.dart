import 'package:flutter/material.dart';
import '../../core/services/sound_manager.dart';

class AudioSettingsScreen extends StatefulWidget {
  const AudioSettingsScreen({super.key});

  @override
  State<AudioSettingsScreen> createState() => _AudioSettingsScreenState();
}

class _AudioSettingsScreenState extends State<AudioSettingsScreen> {
  final SoundManager _soundManager = SoundManager.instance;
  late double _musicVolume;
  late double _sfxVolume;
  late int _selectedTrackIndex;

  @override
  void initState() {
    super.initState();
    _musicVolume = _soundManager.musicVolume;
    _sfxVolume = _soundManager.sfxVolume;
    _selectedTrackIndex = _soundManager.currentTrackIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajustes de Sonido'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const Text(
            'Música',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Row(
            children: [
              const Icon(Icons.music_note),
              Expanded(
                child: Slider(
                  value: _musicVolume,
                  onChanged: (newVolume) {
                    setState(() {
                      _musicVolume = newVolume;
                    });
                    _soundManager.setMusicVolume(newVolume);
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            'Efectos de Sonido (SFX)',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Row(
            children: [
              const Icon(Icons.volume_up),
              Expanded(
                child: Slider(
                  value: _sfxVolume,
                  onChanged: (newVolume) {
                    setState(() {
                      _sfxVolume = newVolume;
                    });
                    _soundManager.setSfxVolume(newVolume);
                    if (newVolume > 0) {
                      // podriamos reproducir un sonido de prueba
                    }
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            'Seleccionar Pista de Música',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          ...List.generate(_soundManager.musicTracks.length, (index) {
            return RadioListTile<int>(
              title: Text(_soundManager.trackTitles[index]),
              value: index,
              groupValue: _selectedTrackIndex,
              onChanged: (int? value) {
                if (value != null) {
                  setState(() {
                    _selectedTrackIndex = value;
                  });
                  _soundManager.changeMusicTrack(value);
                }
              },
            );
          }),
        ],
      ),
    );
  }
}