import 'package:flutter/material.dart';
import '../../data/models/automation_model.dart';

class AutomationViewModel extends ChangeNotifier {
  final List<Automation> _automations = [];
  Automation? _selectedAutomation;
  bool _isLoading = false;
  String? _error;

  // Getters
  List<Automation> get automations => _automations;
  Automation? get selectedAutomation => _selectedAutomation;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Get enabled automations
  List<Automation> get enabledAutomations =>
      _automations.where((a) => a.isEnabled).toList();

  // Select automation
  void selectAutomation(Automation automation) {
    _selectedAutomation = automation;
    notifyListeners();
  }

  // Create automation
  Future<void> createAutomation(Automation automation) async {
    try {
      _setLoading(true);
      _error = null;
      await Future.delayed(const Duration(milliseconds: 400));
      _automations.add(automation);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  // Update automation
  Future<void> updateAutomation(Automation automation) async {
    try {
      _setLoading(true);
      _error = null;
      final index = _automations.indexWhere((a) => a.id == automation.id);
      if (index != -1) {
        await Future.delayed(const Duration(milliseconds: 300));
        _automations[index] = automation;
        _selectedAutomation = automation;
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  // Toggle automation enabled state
  Future<void> toggleAutomation(String automationId) async {
    try {
      final automation = _automations.firstWhere((a) => a.id == automationId);
      await updateAutomation(
        automation.copyWith(isEnabled: !automation.isEnabled),
      );
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  // Delete automation
  Future<void> deleteAutomation(String automationId) async {
    try {
      _setLoading(true);
      _error = null;
      await Future.delayed(const Duration(milliseconds: 300));
      _automations.removeWhere((a) => a.id == automationId);
      if (_selectedAutomation?.id == automationId) {
        _selectedAutomation = null;
      }
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  // Load automations
  Future<void> loadAutomations() async {
    try {
      _setLoading(true);
      _error = null;
      await Future.delayed(const Duration(milliseconds: 500));
      // Load from database
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
