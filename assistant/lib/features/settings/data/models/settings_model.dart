import 'package:uuid/uuid.dart';

class AppSettings {
  final String id;
  final bool darkMode;
  final String language;
  final String defaultAiModel;
  final bool autoSaveEnabled;
  final bool notificationsEnabled;
  final String theme;
  final double fontSize;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Map<String, dynamic> additionalSettings;

  AppSettings({
    String? id,
    this.darkMode = false,
    this.language = 'en',
    this.defaultAiModel = 'gpt-3.5-turbo',
    this.autoSaveEnabled = true,
    this.notificationsEnabled = true,
    this.theme = 'light',
    this.fontSize = 14.0,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.additionalSettings = const {},
  }) : id = id ?? const Uuid().v4(),
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  AppSettings copyWith({
    bool? darkMode,
    String? language,
    String? defaultAiModel,
    bool? autoSaveEnabled,
    bool? notificationsEnabled,
    String? theme,
    double? fontSize,
    Map<String, dynamic>? additionalSettings,
  }) {
    return AppSettings(
      id: id,
      darkMode: darkMode ?? this.darkMode,
      language: language ?? this.language,
      defaultAiModel: defaultAiModel ?? this.defaultAiModel,
      autoSaveEnabled: autoSaveEnabled ?? this.autoSaveEnabled,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      theme: theme ?? this.theme,
      fontSize: fontSize ?? this.fontSize,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
      additionalSettings: additionalSettings ?? this.additionalSettings,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'darkMode': darkMode ? 1 : 0,
      'language': language,
      'defaultAiModel': defaultAiModel,
      'autoSaveEnabled': autoSaveEnabled ? 1 : 0,
      'notificationsEnabled': notificationsEnabled ? 1 : 0,
      'theme': theme,
      'fontSize': fontSize,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory AppSettings.fromMap(Map<String, dynamic> map) {
    return AppSettings(
      id: map['id'] as String? ?? const Uuid().v4(),
      darkMode: (map['darkMode'] as int?) == 1,
      language: map['language'] as String? ?? 'en',
      defaultAiModel: map['defaultAiModel'] as String? ?? 'gpt-3.5-turbo',
      autoSaveEnabled: (map['autoSaveEnabled'] as int?) != 0,
      notificationsEnabled: (map['notificationsEnabled'] as int?) != 0,
      theme: map['theme'] as String? ?? 'light',
      fontSize: (map['fontSize'] as num?)?.toDouble() ?? 14.0,
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'] as String)
          : DateTime.now(),
      updatedAt: map['updatedAt'] != null
          ? DateTime.parse(map['updatedAt'] as String)
          : DateTime.now(),
    );
  }

  @override
  String toString() => 'AppSettings(id: $id, theme: $theme)';
}
