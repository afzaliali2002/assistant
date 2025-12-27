import 'package:flutter/material.dart';
import '../../data/models/user_model.dart';
import '../../data/user_repository.dart';

class UserProfileViewModel extends ChangeNotifier {
  UserProfile? _user;
  bool _isLoading = false;
  String? _error;
  final UserRepository _repository = UserRepository();

  UserProfileViewModel() {
    loadProfile();
  }

  // Getters
  UserProfile? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isLoggedIn => _user != null;

  // Create/Update profile
  Future<void> updateProfile(UserProfile profile) async {
    try {
      _setLoading(true);
      _error = null;
      await _repository.saveProfile(profile);
      _user = profile;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  // Load profile
  Future<void> loadProfile() async {
    try {
      _setLoading(true);
      _error = null;
      final loaded = await _repository.getProfile();
      _user = loaded;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  // Add API key
  Future<void> addAPIKey(String service, String apiKey) async {
    if (_user == null) return;

    try {
      final apiKeys = {..._user!.apiKeys};
      apiKeys[service] = apiKey; // In production, encrypt this

      final updated = _user!.copyWith(apiKeys: apiKeys);
      await updateProfile(updated);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  // Upload and save avatar
  Future<void> uploadAvatar(String filePath) async {
    if (_user == null) return;
    try {
      _setLoading(true);
      _error = null;
      // Delete old avatar if exists
      if (_user!.avatar != null) {
        await _repository.deleteAvatar(_user!.avatar);
      }
      // Save new avatar
      final savedPath = await _repository.saveAvatar(filePath);
      if (savedPath != null) {
        final updated = _user!.copyWith(avatar: savedPath);
        await updateProfile(updated);
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  // Logout
  Future<void> logout() async {
    try {
      _setLoading(true);
      await _repository.logout();
      _user = null;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
