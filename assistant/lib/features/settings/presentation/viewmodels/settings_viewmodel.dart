import 'package:flutter/material.dart';
import '../../data/models/settings_model.dart';
import '../../data/settings_repository.dart';

class SettingsViewModel extends ChangeNotifier {
  AppSettings _settings = AppSettings();
  bool _isLoading = false;
  String? _error;
  final SettingsRepository _repository = SettingsRepository();

  SettingsViewModel() {
    loadSettings();
  }

  // Getters
  AppSettings get settings => _settings;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Load settings
  Future<void> loadSettings() async {
    try {
      _setLoading(true);
      _error = null;
      final loaded = await _repository.getSettings();
      _settings = loaded;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  // Update settings
  Future<void> updateSettings(AppSettings settings) async {
    try {
      _setLoading(true);
      _error = null;
      await _repository.saveSettings(settings);
      _settings = settings;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  // Toggle dark mode
  Future<void> toggleDarkMode() async {
    final updated = _settings.copyWith(darkMode: !_settings.darkMode);
    await updateSettings(updated);
  }

  // Set language
  Future<void> setLanguage(String language) async {
    final updated = _settings.copyWith(language: language);
    await updateSettings(updated);
  }

  // Set default AI model
  Future<void> setDefaultAIModel(String model) async {
    final updated = _settings.copyWith(defaultAiModel: model);
    await updateSettings(updated);
  }

  // Save API key
  Future<void> saveAPIKey(String service, String key) async {
    try {
      final updated = _settings.copyWith(
        additionalSettings: {
          ..._settings.additionalSettings,
          '${service}_key': key,
        },
      );
      await updateSettings(updated);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  // Get API key
  String? getAPIKey(String service) {
    return _settings.additionalSettings['${service}_key'] as String?;
  }

  void _setLoading(bool value) {
    _isLoading = value;
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
