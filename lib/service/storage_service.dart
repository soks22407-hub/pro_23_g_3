

import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  Future<SharedPreferences> get _prefs => SharedPreferences.getInstance();

  Future<void> saveString(String key, String value) async {
    await (await _prefs).setString(key, value);
  }

  Future<String?> getString(String key) async {
    return (await _prefs).getString(key);
  }

  Future<void> saveInt(String key, int value) async {
    await (await _prefs).setInt(key, value);
  }

  Future<int?> getInt(String key) async {
    return (await _prefs).getInt(key);
  }

  Future<void> saveBool(String key, bool value) async {
    await (await _prefs).setBool(key, value);
  }

  Future<bool?> getBool(String key) async {
    return (await _prefs).getBool(key);
  }

  Future<void> remove(String key) async {
    await (await _prefs).remove(key);
  }

  Future<void> clear() async {
    await (await _prefs).clear();
  }
}