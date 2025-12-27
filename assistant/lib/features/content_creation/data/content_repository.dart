import 'dart:convert';

import '../../../core/services/storage_service.dart';
import 'models/content_model.dart';

class ContentRepository {
  final StorageService _storage = StorageService();
  final String _key = 'content_creation_v1';

  Future<List<Content>> getAllContent() async {
    try {
      final jsonStr = _storage.getString(_key);
      if (jsonStr == null || jsonStr.isEmpty) return [];
      final decoded = jsonDecode(jsonStr) as List<dynamic>;
      return decoded
          .map((e) => Content.fromMap(Map<String, dynamic>.from(e)))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> saveAll(List<Content> contents) async {
    final jsonStr = jsonEncode(contents.map((c) => c.toMap()).toList());
    await _storage.setString(_key, jsonStr);
  }

  Future<void> addContent(Content content) async {
    final contents = await getAllContent();
    contents.add(content);
    await saveAll(contents);
  }

  Future<void> updateContent(Content content) async {
    final contents = await getAllContent();
    final index = contents.indexWhere((c) => c.id == content.id);
    if (index != -1) {
      contents[index] = content;
      await saveAll(contents);
    }
  }

  Future<void> deleteContent(String id) async {
    final contents = await getAllContent();
    contents.removeWhere((c) => c.id == id);
    await saveAll(contents);
  }
}
