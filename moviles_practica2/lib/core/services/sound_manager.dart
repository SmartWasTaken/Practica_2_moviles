import 'package:audioplayers/audioplayers.dart';
import '../../data/repositories/preferences_repository.dart';

class SoundManager {
  SoundManager._privateConstructor();
  static final SoundManager instance = SoundManager._privateConstructor();

  final AudioPlayer _musicPlayer = AudioPlayer();
  final AudioPlayer _sfxPlayer = AudioPlayer();
  final PreferencesRepository _prefs = PreferencesRepository();

  double _musicVolume = 0.5;
  double _sfxVolume = 1.0;
  int _currentTrackIndex = 0;

  final List<String> musicTracks = [
    'audio/music/music_loop.mp3',
    'audio/music/track_2.mp3',
    'audio/music/track_3.mp3',
    'audio/music/track_4.mp3',
  ];

  final List<String> trackTitles = [
    'Victor`s Piano Solo',
    'Overture (La novia cadaver)',
    'Out There (El jorobado de Notre Dame)',
    'Introduction (Eduardo Manostijeras)',
  ];

  Future<void> init() async {
    final AudioContext audioContext = AudioContext(
      iOS: AudioContextIOS(
        category: AVAudioSessionCategory.playback,
        options: {
          AVAudioSessionOptions.mixWithOthers,
        },
      ),
      android: AudioContextAndroid(
        isSpeakerphoneOn: true,
        stayAwake: true,
        contentType: AndroidContentType.music,
        usageType: AndroidUsageType.game,
        audioFocus: AndroidAudioFocus.none,
      ),
    );

    await AudioPlayer.global.setAudioContext(audioContext);

    _musicVolume = await _prefs.getMusicVolume();
    _sfxVolume = await _prefs.getSfxVolume();
    _currentTrackIndex = await _prefs.getSelectedMusicTrack();

    await _musicPlayer.setReleaseMode(ReleaseMode.loop);
    await _musicPlayer.setVolume(_musicVolume);
    await _sfxPlayer.setVolume(_sfxVolume);

    await playMusic();
  }

  Future<void> playMusic() async {
    if (_musicVolume > 0) {
      try {
        // Si ya está sonando algo, lo paramos para cambiar de pista
        if (_musicPlayer.state == PlayerState.playing) {
          await _musicPlayer.stop();
        }
        await _musicPlayer.play(AssetSource(musicTracks[_currentTrackIndex]));
      } catch (e) {
        print("Error playing music: $e");
      }
    }
  }

  Future<void> playSfx(String fileName) async {
    if (_sfxVolume > 0) {
      try {
        await _sfxPlayer.stop();
        await _sfxPlayer.play(AssetSource('audio/sfx/$fileName'));
      } catch (e) {
        print("Error playing SFX: $e");
      }
    }
  }

  Future<void> setMusicVolume(double volume) async {
    _musicVolume = volume.clamp(0.0, 1.0);
    await _musicPlayer.setVolume(_musicVolume);
    await _prefs.saveMusicVolume(_musicVolume);

    if (_musicVolume > 0 && _musicPlayer.state != PlayerState.playing) {
      playMusic();
    } else if (_musicVolume == 0) {
      _musicPlayer.pause();
    }
  }

  Future<void> setSfxVolume(double volume) async {
    _sfxVolume = volume.clamp(0.0, 1.0);
    await _sfxPlayer.setVolume(_sfxVolume);
    await _prefs.saveSfxVolume(_sfxVolume);
  }

  Future<void> changeMusicTrack(int index) async {
    if (index >= 0 && index < musicTracks.length) {
      _currentTrackIndex = index;
      await _prefs.saveSelectedMusicTrack(index);
      await playMusic();
    }
  }

  double get musicVolume => _musicVolume;
  double get sfxVolume => _sfxVolume;
  int get currentTrackIndex => _currentTrackIndex;

  void pauseMusic() {
    _musicPlayer.pause();
  }

  void resumeMusic() {
    if (_musicVolume > 0) {
      _musicPlayer.resume();
    }
  }
}