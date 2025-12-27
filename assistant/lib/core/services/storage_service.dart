import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static final StorageService _instance = StorageService._internal();
  late final SharedPreferences _preferences;

  StorageService._internal();

  factory StorageService() {
    return _instance;
  }

  Future<void> initialize() async {
    _preferences = await SharedPreferences.getInstance();
  }

  Future<bool> setString(String key, String value) async {
    return _preferences.setString(key, value);
  }

  Future<bool> setInt(String key, int value) async {
    return _preferences.setInt(key, value);
  }

  Future<bool> setBool(String key, bool value) async {
    return _preferences.setBool(key, value);
  }

  Future<bool> setDouble(String key, double value) async {
    return _preferences.setDouble(key, value);
  }

  Future<bool> setStringList(String key, List<String> value) async {
    return _preferences.setStringList(key, value);
  }

  String? getString(String key) {
    return _preferences.getString(key);
  }

  int? getInt(String key) {
    return _preferences.getInt(key);
  }

  bool? getBool(String key) {
    return _preferences.getBool(key);
  }

  double? getDouble(String key) {
    return _preferences.getDouble(key);
  }

  List<String>? getStringList(String key) {
    return _preferences.getStringList(key);
  }

  Future<bool> remove(String key) async {
    return _preferences.remove(key);
  }

  Future<bool> clear() async {
    return _preferences.clear();
  }

  bool containsKey(String key) {
    return _preferences.containsKey(key);
  }

  Set<String> getKeys() {
    return _preferences.getKeys();
  }
}
