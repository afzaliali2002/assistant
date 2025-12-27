import 'package:uuid/uuid.dart';

class Conversation {
  final String id;
  final String title;
  final String? description;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<Message> messages;
  final String aiModel;
  final Map<String, dynamic> metadata;

  Conversation({
    String? id,
    required this.title,
    this.description,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.messages = const [],
    this.aiModel = 'gpt-3.5-turbo',
    this.metadata = const {},
  }) : id = id ?? const Uuid().v4(),
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  Conversation copyWith({
    String? title,
    String? description,
    List<Message>? messages,
    String? aiModel,
    Map<String, dynamic>? metadata,
  }) {
    return Conversation(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
      messages: messages ?? this.messages,
      aiModel: aiModel ?? this.aiModel,
      metadata: metadata ?? this.metadata,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'aiModel': aiModel,
      'messages': messages.map((m) => m.toMap()).toList(),
    };
  }

  factory Conversation.fromMap(Map<String, dynamic> map) {
    return Conversation(
      id: map['id'] as String,
      title: map['title'] as String,
      description: map['description'] as String?,
      createdAt: DateTime.parse(map['createdAt'] as String),
      updatedAt: DateTime.parse(map['updatedAt'] as String),
      aiModel: map['aiModel'] as String? ?? 'gpt-3.5-turbo',
      messages: (map['messages'] as List<dynamic>?)
              ?.map((e) => Message.fromMap(Map<String, dynamic>.from(e)))
              .toList() ??
          [],
    );
  }

  @override
  String toString() => 'Conversation(id: $id, title: $title)';
}

class Message {
  final String id;
  final String conversationId;
  final String content;
  final String role; // 'user', 'assistant'
  final String? aiModel;
  final DateTime createdAt;
  final List<String>? attachments;
  final Map<String, dynamic>? metadata;

  Message({
    String? id,
    required this.conversationId,
    required this.content,
    required this.role,
    this.aiModel,
    DateTime? createdAt,
    this.attachments,
    this.metadata,
  }) : id = id ?? const Uuid().v4(),
       createdAt = createdAt ?? DateTime.now();

  Message copyWith({
    String? content,
    String? role,
    String? aiModel,
    List<String>? attachments,
  }) {
    return Message(
      id: id,
      conversationId: conversationId,
      content: content ?? this.content,
      role: role ?? this.role,
      aiModel: aiModel ?? this.aiModel,
      createdAt: createdAt,
      attachments: attachments ?? this.attachments,
      metadata: metadata,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'conversationId': conversationId,
      'content': content,
      'role': role,
      'aiModel': aiModel,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      id: map['id'] as String,
      conversationId: map['conversationId'] as String,
      content: map['content'] as String,
      role: map['role'] as String,
      aiModel: map['aiModel'] as String?,
      createdAt: DateTime.parse(map['createdAt'] as String),
    );
  }

  @override
  String toString() => 'Message(id: $id, role: $role)';
}
