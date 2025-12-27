import 'dart:convert';

import '../../../core/services/storage_service.dart';
import 'models/voice_vision_model.dart';

class VoiceVisionRepository {
  final StorageService _storage = StorageService();
  final String _imageKey = 'voice_vision_images_v1';

  Future<List<ImageData>> getAllImages() async {
    try {
      final jsonStr = _storage.getString(_imageKey);
      if (jsonStr == null || jsonStr.isEmpty) return [];
      final decoded = jsonDecode(jsonStr) as List<dynamic>;
      return decoded
          .map((e) => ImageData.fromMap(Map<String, dynamic>.from(e)))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> saveAllImages(List<ImageData> images) async {
    final jsonStr = jsonEncode(images.map((i) => i.toMap()).toList());
    await _storage.setString(_imageKey, jsonStr);
  }

  Future<void> addImage(ImageData image) async {
    final images = await getAllImages();
    images.add(image);
    await saveAllImages(images);
  }

  Future<void> updateImage(ImageData image) async {
    final images = await getAllImages();
    final index = images.indexWhere((i) => i.id == image.id);
    if (index != -1) {
      images[index] = image;
      await saveAllImages(images);
    }
  }

  Future<void> deleteImage(String id) async {
    final images = await getAllImages();
    images.removeWhere((i) => i.id == id);
    await saveAllImages(images);
  }
}
