import 'package:uuid/uuid.dart';

enum VoiceInputStatus { idle, listening, processing, completed, failed }

class VoiceInput {
  final String id;
  final String audioPath;
  final String? transcription;
  final VoiceInputStatus status;
  final double confidence;
  final DateTime createdAt;
  final String? processedBy; // AI model used
  final int duration; // in milliseconds

  VoiceInput({
    String? id,
    required this.audioPath,
    this.transcription,
    this.status = VoiceInputStatus.idle,
    this.confidence = 0.0,
    DateTime? createdAt,
    this.processedBy,
    this.duration = 0,
  }) : id = id ?? const Uuid().v4(),
       createdAt = createdAt ?? DateTime.now();

  VoiceInput copyWith({
    String? transcription,
    VoiceInputStatus? status,
    double? confidence,
    String? processedBy,
  }) {
    return VoiceInput(
      id: id,
      audioPath: audioPath,
      transcription: transcription ?? this.transcription,
      status: status ?? this.status,
      confidence: confidence ?? this.confidence,
      createdAt: createdAt,
      processedBy: processedBy ?? this.processedBy,
      duration: duration,
    );
  }

  @override
  String toString() =>
      'VoiceInput(id: $id, status: $status, confidence: $confidence)';
}

class ImageData {
  final String id;
  final String imagePath;
  final String? description;
  final Map<String, dynamic>? analysis;
  final DateTime createdAt;
  final String? processedBy; // AI model used
  final List<String> detectedObjects;

  ImageData({
    String? id,
    required this.imagePath,
    this.description,
    this.analysis,
    DateTime? createdAt,
    this.processedBy,
    this.detectedObjects = const [],
  }) : id = id ?? const Uuid().v4(),
       createdAt = createdAt ?? DateTime.now();

  ImageData copyWith({
    String? description,
    Map<String, dynamic>? analysis,
    String? processedBy,
    List<String>? detectedObjects,
  }) {
    return ImageData(
      id: id,
      imagePath: imagePath,
      description: description ?? this.description,
      analysis: analysis ?? this.analysis,
      createdAt: createdAt,
      processedBy: processedBy ?? this.processedBy,
      detectedObjects: detectedObjects ?? this.detectedObjects,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'imagePath': imagePath,
      'description': description,
      'createdAt': createdAt.toIso8601String(),
      'processedBy': processedBy,
      'detectedObjects': detectedObjects.join(','),
    };
  }

  factory ImageData.fromMap(Map<String, dynamic> map) {
    return ImageData(
      id: map['id'] as String,
      imagePath: map['imagePath'] as String,
      description: map['description'] as String?,
      createdAt: DateTime.parse(map['createdAt'] as String),
      processedBy: map['processedBy'] as String?,
      detectedObjects: (map['detectedObjects'] as String?)?.split(',') ?? [],
    );
  }

  @override
  String toString() => 'ImageData(id: $id, imagePath: $imagePath)';
}
