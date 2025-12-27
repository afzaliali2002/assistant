import 'dart:convert';

import '../../../core/services/storage_service.dart';
import 'models/automation_model.dart';

class AutomationRepository {
  final StorageService _storage = StorageService();
  final String _key = 'automations_v1';

  Future<List<Automation>> getAllAutomations() async {
    try {
      final jsonStr = _storage.getString(_key);
      if (jsonStr == null || jsonStr.isEmpty) return [];
      final decoded = jsonDecode(jsonStr) as List<dynamic>;
      return decoded
          .map((e) => Automation.fromMap(Map<String, dynamic>.from(e)))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> saveAll(List<Automation> automations) async {
    final jsonStr = jsonEncode(automations.map((a) => a.toMap()).toList());
    await _storage.setString(_key, jsonStr);
  }

  Future<void> addAutomation(Automation automation) async {
    final automations = await getAllAutomations();
    automations.add(automation);
    await saveAll(automations);
  }

  Future<void> updateAutomation(Automation automation) async {
    final automations = await getAllAutomations();
    final index = automations.indexWhere((a) => a.id == automation.id);
    if (index != -1) {
      automations[index] = automation;
      await saveAll(automations);
    }
  }

  Future<void> deleteAutomation(String id) async {
    final automations = await getAllAutomations();
    automations.removeWhere((a) => a.id == id);
    await saveAll(automations);
  }
}
