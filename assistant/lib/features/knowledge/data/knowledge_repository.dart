import 'dart:convert';

import '../../../core/services/storage_service.dart';
import 'models/knowledge_model.dart';

class KnowledgeRepository {
  final StorageService _storage = StorageService();
  final String _key = 'knowledge_items_v1';

  Future<List<KnowledgeItem>> getAllItems() async {
    try {
      final jsonStr = _storage.getString(_key);
      if (jsonStr == null || jsonStr.isEmpty) return [];
      final decoded = jsonDecode(jsonStr) as List<dynamic>;
      return decoded
          .map((e) => KnowledgeItem.fromMap(Map<String, dynamic>.from(e)))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> saveAll(List<KnowledgeItem> items) async {
    final jsonStr = jsonEncode(items.map((k) => k.toMap()).toList());
    await _storage.setString(_key, jsonStr);
  }

  Future<void> addItem(KnowledgeItem item) async {
    final items = await getAllItems();
    items.add(item);
    await saveAll(items);
  }

  Future<void> updateItem(KnowledgeItem item) async {
    final items = await getAllItems();
    final index = items.indexWhere((k) => k.id == item.id);
    if (index != -1) {
      items[index] = item;
      await saveAll(items);
    }
  }

  Future<void> deleteItem(String id) async {
    final items = await getAllItems();
    items.removeWhere((k) => k.id == id);
    await saveAll(items);
  }

  // Search items by title or content
  Future<List<KnowledgeItem>> searchItems(String query) async {
    final items = await getAllItems();
    return items
        .where((k) =>
            k.title.toLowerCase().contains(query.toLowerCase()) ||
            k.content.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  // Get items by category
  Future<List<KnowledgeItem>> getByCategory(String category) async {
    final items = await getAllItems();
    return items.where((k) => k.category == category).toList();
  }

  // Get favorite items
  Future<List<KnowledgeItem>> getFavorites() async {
    final items = await getAllItems();
    return items.where((k) => k.isFavorite).toList();
  }
}
