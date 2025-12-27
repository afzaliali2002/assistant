import 'package:uuid/uuid.dart';

class UserProfile {
  final String id;
  final String email;
  final String fullName;
  final String? avatar;
  final String? bio;
  final String? preferredLanguage;
  final List<String> preferences;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool emailVerified;
  final Map<String, String> apiKeys; // Store encrypted API keys

  UserProfile({
    String? id,
    required this.email,
    required this.fullName,
    this.avatar,
    this.bio,
    this.preferredLanguage = 'en',
    this.preferences = const [],
    DateTime? createdAt,
    DateTime? updatedAt,
    this.emailVerified = false,
    this.apiKeys = const {},
  }) : id = id ?? const Uuid().v4(),
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  UserProfile copyWith({
    String? fullName,
    String? avatar,
    String? bio,
    String? preferredLanguage,
    List<String>? preferences,
    bool? emailVerified,
    Map<String, String>? apiKeys,
  }) {
    return UserProfile(
      id: id,
      email: email,
      fullName: fullName ?? this.fullName,
      avatar: avatar ?? this.avatar,
      bio: bio ?? this.bio,
      preferredLanguage: preferredLanguage ?? this.preferredLanguage,
      preferences: preferences ?? this.preferences,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
      emailVerified: emailVerified ?? this.emailVerified,
      apiKeys: apiKeys ?? this.apiKeys,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'fullName': fullName,
      'avatar': avatar,
      'bio': bio,
      'preferredLanguage': preferredLanguage,
      'preferences': preferences.join(','),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'emailVerified': emailVerified ? 1 : 0,
    };
  }

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      id: map['id'] as String,
      email: map['email'] as String,
      fullName: map['fullName'] as String,
      avatar: map['avatar'] as String?,
      bio: map['bio'] as String?,
      preferredLanguage: map['preferredLanguage'] as String? ?? 'en',
      preferences: (map['preferences'] as String?)?.split(',') ?? [],
      createdAt: DateTime.parse(map['createdAt'] as String),
      updatedAt: DateTime.parse(map['updatedAt'] as String),
      emailVerified: (map['emailVerified'] as int?) == 1,
    );
  }

  @override
  String toString() => 'UserProfile(id: $id, email: $email)';
}
