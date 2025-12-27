import 'package:uuid/uuid.dart';

class KnowledgeItem {
  final String id;
  final String title;
  final String content;
  final String? category;
  final List<String> tags;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int views;
  final bool isFavorite;
  final String? source;

  KnowledgeItem({
    String? id,
    required this.title,
    required this.content,
    this.category,
    this.tags = const [],
    DateTime? createdAt,
    DateTime? updatedAt,
    this.views = 0,
    this.isFavorite = false,
    this.source,
  }) : id = id ?? const Uuid().v4(),
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  KnowledgeItem copyWith({
    String? title,
    String? content,
    String? category,
    List<String>? tags,
    int? views,
    bool? isFavorite,
  }) {
    return KnowledgeItem(
      id: id,
      title: title ?? this.title,
      content: content ?? this.content,
      category: category ?? this.category,
      tags: tags ?? this.tags,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
      views: views ?? this.views,
      isFavorite: isFavorite ?? this.isFavorite,
      source: source,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'category': category,
      'tags': tags.join(','),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'views': views,
      'isFavorite': isFavorite ? 1 : 0,
    };
  }

  factory KnowledgeItem.fromMap(Map<String, dynamic> map) {
    return KnowledgeItem(
      id: map['id'] as String,
      title: map['title'] as String,
      content: map['content'] as String,
      category: map['category'] as String?,
      tags: (map['tags'] as String?)?.split(',') ?? [],
      createdAt: DateTime.parse(map['createdAt'] as String),
      updatedAt: DateTime.parse(map['updatedAt'] as String),
      views: (map['views'] as int?) ?? 0,
      isFavorite: (map['isFavorite'] as int?) == 1,
    );
  }

  @override
  String toString() => 'KnowledgeItem(id: $id, title: $title)';
}
