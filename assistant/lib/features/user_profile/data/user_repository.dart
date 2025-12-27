import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

import '../../../core/services/storage_service.dart';
import 'models/user_model.dart';

class UserRepository {
  final StorageService _storage = StorageService();
  final String _key = 'user_profile_v1';
  Future<String> getAvatarDir() async {
    final dir = await getApplicationDocumentsDirectory();
    final avatarDir = Directory('${dir.path}/avatars');
    if (!await avatarDir.exists()) {
      await avatarDir.create(recursive: true);
    }
    return avatarDir.path;
  }

  Future<UserProfile?> getProfile() async {
    try {
      final jsonStr = _storage.getString(_key);
      if (jsonStr == null || jsonStr.isEmpty) return null;
      final map = jsonDecode(jsonStr) as Map<String, dynamic>;
      return UserProfile.fromMap(map);
    } catch (_) {
      return null;
    }
  }

  Future<void> saveProfile(UserProfile profile) async {
    final jsonStr = jsonEncode(profile.toMap());
    await _storage.setString(_key, jsonStr);
  }

  // Save avatar from file path (copy to app documents)
  Future<String?> saveAvatar(String filePath) async {
    try {
      final avatarDir = await getAvatarDir();
      final fileName = 'avatar_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final savedFile = File('$avatarDir/$fileName');
      await File(filePath).copy(savedFile.path);
      return savedFile.path;
    } catch (_) {
      return null;
    }
  }

  // Delete avatar file
  Future<void> deleteAvatar(String? filePath) async {
    if (filePath == null) return;
    try {
      final file = File(filePath);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (_) {}
  }

  Future<void> logout() async {
    final profile = await getProfile();
    if (profile?.avatar != null) {
      await deleteAvatar(profile!.avatar);
    }
    await _storage.remove(_key);
  }
}
