import 'package:uuid/uuid.dart';

enum AutomationTrigger { time, event, condition, manual }

enum AutomationAction { notification, task, message, email, webhook }

class Automation {
  final String id;
  final String name;
  final String description;
  final AutomationTrigger trigger;
  final AutomationAction action;
  final Map<String, dynamic> triggerConfig;
  final Map<String, dynamic> actionConfig;
  final bool isEnabled;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int executionCount;
  final DateTime? lastExecuted;

  Automation({
    String? id,
    required this.name,
    required this.description,
    required this.trigger,
    required this.action,
    required this.triggerConfig,
    required this.actionConfig,
    this.isEnabled = true,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.executionCount = 0,
    this.lastExecuted,
  }) : id = id ?? const Uuid().v4(),
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  Automation copyWith({
    String? name,
    String? description,
    AutomationTrigger? trigger,
    AutomationAction? action,
    Map<String, dynamic>? triggerConfig,
    Map<String, dynamic>? actionConfig,
    bool? isEnabled,
  }) {
    return Automation(
      id: id,
      name: name ?? this.name,
      description: description ?? this.description,
      trigger: trigger ?? this.trigger,
      action: action ?? this.action,
      triggerConfig: triggerConfig ?? this.triggerConfig,
      actionConfig: actionConfig ?? this.actionConfig,
      isEnabled: isEnabled ?? this.isEnabled,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
      executionCount: executionCount,
      lastExecuted: lastExecuted,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'trigger': trigger.toString().split('.').last,
      'action': action.toString().split('.').last,
      'isEnabled': isEnabled ? 1 : 0,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory Automation.fromMap(Map<String, dynamic> map) {
    return Automation(
      id: map['id'] as String,
      name: map['name'] as String,
      description: map['description'] as String? ?? '',
      trigger: AutomationTrigger.values.firstWhere(
        (e) => e.toString().split('.').last == map['trigger'],
        orElse: () => AutomationTrigger.manual,
      ),
      action: AutomationAction.values.firstWhere(
        (e) => e.toString().split('.').last == map['action'],
        orElse: () => AutomationAction.notification,
      ),
      triggerConfig: const {},
      actionConfig: const {},
      isEnabled: (map['isEnabled'] as int?) == 1,
      createdAt: DateTime.parse(map['createdAt'] as String),
      updatedAt: DateTime.parse(map['updatedAt'] as String),
    );
  }

  @override
  String toString() => 'Automation(id: $id, name: $name)';
}
