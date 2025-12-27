import 'package:flutter/material.dart';

import '../../data/models/task_model.dart';
import '../../data/task_repository.dart';

class TaskViewModel extends ChangeNotifier {
  final List<Task> _tasks = [];
  Task? _selectedTask;
  bool _isLoading = false;
  String? _error;
  final TaskRepository _repository = TaskRepository();

  TaskViewModel() {
    loadTasks();
  }

  // Getters
  List<Task> get tasks => _tasks;
  Task? get selectedTask => _selectedTask;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Get filtered tasks by status
  List<Task> getTasksByStatus(TaskStatus status) {
    return _tasks.where((task) => task.status == status).toList();
  }

  // Get completed tasks percentage
  double getCompletionPercentage() {
    if (_tasks.isEmpty) return 0;
    final completed = _tasks
        .where((t) => t.status == TaskStatus.completed)
        .length;
    return (completed / _tasks.length) * 100;
  }

  // Create new task
  Future<void> createTask(Task task) async {
    try {
      _setLoading(true);
      _error = null;
      await _repository.addTask(task);
      _tasks.add(task);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  // Update task
  Future<void> updateTask(Task task) async {
    try {
      _setLoading(true);
      _error = null;
      final index = _tasks.indexWhere((t) => t.id == task.id);
      if (index != -1) {
        await _repository.updateTask(task);
        _tasks[index] = task;
        _selectedTask = task;
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  // Delete task
  Future<void> deleteTask(String taskId) async {
    try {
      _setLoading(true);
      _error = null;
      await _repository.deleteTask(taskId);
      _tasks.removeWhere((t) => t.id == taskId);
      if (_selectedTask?.id == taskId) {
        _selectedTask = null;
      }
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  // Select task
  void selectTask(Task task) {
    _selectedTask = task;
    notifyListeners();
  }

  // Mark task as complete
  Future<void> completeTask(String taskId) async {
    final task = _tasks.firstWhere((t) => t.id == taskId);
    await updateTask(task.copyWith(status: TaskStatus.completed));
  }

  // Update task progress
  Future<void> updateTaskProgress(String taskId, int percentage) async {
    final task = _tasks.firstWhere((t) => t.id == taskId);
    await updateTask(task.copyWith(percentComplete: percentage));
  }

  // Load tasks
  Future<void> loadTasks() async {
    try {
      _setLoading(true);
      _error = null;
      final loaded = await _repository.getAllTasks();
      _tasks.clear();
      _tasks.addAll(loaded);
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
