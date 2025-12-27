import 'dart:convert';

import '../../../core/services/storage_service.dart';
import 'models/settings_model.dart';

class SettingsRepository {
  final StorageService _storage = StorageService();
  final String _key = 'app_settings_v1';

  Future<AppSettings> getSettings() async {
    try {
      final jsonStr = _storage.getString(_key);
      if (jsonStr == null || jsonStr.isEmpty) {
        return AppSettings();
      }
      final map = jsonDecode(jsonStr) as Map<String, dynamic>;
      return AppSettings.fromMap(map);
    } catch (_) {
      return AppSettings();
    }
  }

  Future<void> saveSettings(AppSettings settings) async {
    final jsonStr = jsonEncode(settings.toMap());
    await _storage.setString(_key, jsonStr);
  }

  Future<void> resetToDefaults() async {
    await _storage.remove(_key);
  }
}
