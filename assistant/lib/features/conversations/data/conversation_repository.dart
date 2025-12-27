import 'dart:convert';

import '../../../core/services/storage_service.dart';
import 'models/conversation_model.dart';

class ConversationRepository {
  final StorageService _storage = StorageService();
  final String _key = 'conversations_v1';

  Future<List<Conversation>> getAllConversations() async {
    try {
      final jsonStr = _storage.getString(_key);
      if (jsonStr == null || jsonStr.isEmpty) return [];
      final decoded = jsonDecode(jsonStr) as List<dynamic>;
      return decoded
          .map((e) => Conversation.fromMap(Map<String, dynamic>.from(e)))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> saveAll(List<Conversation> convs) async {
    final jsonStr = jsonEncode(convs.map((c) => c.toMap()).toList());
    await _storage.setString(_key, jsonStr);
  }

  Future<void> addConversation(Conversation conv) async {
    final convs = await getAllConversations();
    convs.add(conv);
    await saveAll(convs);
  }

  Future<void> updateConversation(Conversation conv) async {
    final convs = await getAllConversations();
    final index = convs.indexWhere((c) => c.id == conv.id);
    if (index != -1) {
      convs[index] = conv;
      await saveAll(convs);
    }
  }

  Future<void> deleteConversation(String id) async {
    final convs = await getAllConversations();
    convs.removeWhere((c) => c.id == id);
    await saveAll(convs);
  }
}
