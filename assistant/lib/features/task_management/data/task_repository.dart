import 'dart:convert';

import 'package:flutter/foundation.dart';
import '../../../core/services/storage_service.dart';
import 'models/task_model.dart';

class TaskRepository {
  final StorageService _storage = StorageService();
  final String _key = 'task_management_tasks';

  Future<List<Task>> getAllTasks() async {
    try {
      final jsonStr = _storage.getString(_key);
      if (jsonStr == null || jsonStr.isEmpty) return [];
      final decoded = jsonDecode(jsonStr) as List<dynamic>;
      return decoded
          .map((e) => Task.fromMap(Map<String, dynamic>.from(e)))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> saveAll(List<Task> tasks) async {
    final jsonStr = jsonEncode(tasks.map((t) => t.toMap()).toList());
    await _storage.setString(_key, jsonStr);
  }

  Future<void> addTask(Task task) async {
    final tasks = await getAllTasks();
    tasks.add(task);
    await saveAll(tasks);
  }

  Future<void> updateTask(Task task) async {
    final tasks = await getAllTasks();
    final index = tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      tasks[index] = task;
      await saveAll(tasks);
    }
  }

  Future<void> deleteTask(String id) async {
    final tasks = await getAllTasks();
    tasks.removeWhere((t) => t.id == id);
    await saveAll(tasks);
  }
}
