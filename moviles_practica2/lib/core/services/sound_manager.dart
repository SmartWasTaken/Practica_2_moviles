import 'package:audioplayers/audioplayers.dart';

class SoundManager {
  //Singelton
  SoundManager._privateConstructor();
  static final SoundManager instance = SoundManager._privateConstructor();

  final AudioPlayer _musicPlayer = AudioPlayer();
  double _volume = 1.0;

  Future<void> init() async {
    _musicPlayer.setReleaseMode(ReleaseMode.loop);
  }

  Future<void> playMusic(String fileName) async {
    await _musicPlayer.stop();
    await _musicPlayer.play(AssetSource(fileName));
  }

  Future<void> stopMusic() async {
    await _musicPlayer.stop();
  }

  Future<void> setVolume(double volume) async {
    _volume = volume.clamp(0.0, 1.0);
    await _musicPlayer.setVolume(_volume);
  }

  double get currentVolume => _volume;

  void pauseMusic() {
    _musicPlayer.pause();
  }

  void resumeMusic() {
    _musicPlayer.resume();
  }
}