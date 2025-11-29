import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/enums.dart';

class PreferencesRepository {
  static const _difficultyKey = 'game_difficulty';
  static const _musicVolumeKey = 'music_volume';
  static const _sfxVolumeKey = 'sfx_volume';
  static const _selectedMusicKey = 'selected_music_track';
  static const _highContrastKey = 'high_contrast';
  static const _hapticsKey = 'haptics_enabled';

  Future<void> saveDifficulty(Difficulty difficulty) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_difficultyKey, difficulty.toString().split('.').last);
  }

  Future<Difficulty> getDifficulty() async {
    final prefs = await SharedPreferences.getInstance();
    final savedDifficulty = prefs.getString(_difficultyKey);

    if (savedDifficulty == null) {
      return Difficulty.medio;
    }

    switch (savedDifficulty) {
      case 'facil':
        return Difficulty.facil;
      case 'dificil':
        return Difficulty.dificil;
      case 'medio':
      default:
        return Difficulty.medio;
    }
  }

  Future<void> saveMusicVolume(double volume) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_musicVolumeKey, volume);
  }

  Future<double> getMusicVolume() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(_musicVolumeKey) ?? 0.5;
  }

  Future<void> saveSfxVolume(double volume) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_sfxVolumeKey, volume);
  }

  Future<double> getSfxVolume() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(_sfxVolumeKey) ?? 1.0;
  }

  Future<void> saveSelectedMusicTrack(int index) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_selectedMusicKey, index);
  }

  Future<int> getSelectedMusicTrack() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_selectedMusicKey) ?? 0;
  }

  Future<void> saveHighContrast(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_highContrastKey, value);
  }

  Future<bool> getHighContrast() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_highContrastKey) ?? false;
  }

  Future<void> saveHaptics(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_hapticsKey, value);
  }

  Future<bool> getHaptics() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_hapticsKey) ?? true;
  }
}