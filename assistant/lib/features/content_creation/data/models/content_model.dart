import 'package:uuid/uuid.dart';

enum ContentType { article, blog, code, documentation, social, email }

class Content {
  final String id;
  final String title;
  final String body;
  final ContentType type;
  final String? aiModel;
  final List<String> keywords;
  final Map<String, dynamic> metadata;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isPublished;
  final int likes;
  final int shares;

  Content({
    String? id,
    required this.title,
    required this.body,
    required this.type,
    this.aiModel,
    this.keywords = const [],
    this.metadata = const {},
    DateTime? createdAt,
    DateTime? updatedAt,
    this.isPublished = false,
    this.likes = 0,
    this.shares = 0,
  }) : id = id ?? const Uuid().v4(),
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  Content copyWith({
    String? title,
    String? body,
    ContentType? type,
    String? aiModel,
    List<String>? keywords,
    bool? isPublished,
  }) {
    return Content(
      id: id,
      title: title ?? this.title,
      body: body ?? this.body,
      type: type ?? this.type,
      aiModel: aiModel ?? this.aiModel,
      keywords: keywords ?? this.keywords,
      metadata: metadata,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
      isPublished: isPublished ?? this.isPublished,
      likes: likes,
      shares: shares,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'type': type.toString().split('.').last,
      'aiModel': aiModel,
      'keywords': keywords.join(','),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'isPublished': isPublished ? 1 : 0,
    };
  }

  factory Content.fromMap(Map<String, dynamic> map) {
    return Content(
      id: map['id'] as String,
      title: map['title'] as String,
      body: map['body'] as String,
      type: ContentType.values.firstWhere(
        (e) => e.toString().split('.').last == map['type'],
        orElse: () => ContentType.article,
      ),
      aiModel: map['aiModel'] as String?,
      keywords: (map['keywords'] as String?)?.split(',') ?? [],
      createdAt: DateTime.parse(map['createdAt'] as String),
      updatedAt: DateTime.parse(map['updatedAt'] as String),
      isPublished: (map['isPublished'] as int?) == 1,
    );
  }

  @override
  String toString() => 'Content(id: $id, title: $title)';
}
