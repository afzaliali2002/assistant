import 'package:flutter/material.dart';
import '../../data/models/voice_vision_model.dart';

class VoiceVisionViewModel extends ChangeNotifier {
  final List<VoiceInput> _voiceInputs = [];
  final List<ImageData> _images = [];
  bool _isRecording = false;
  bool _isProcessing = false;
  String? _error;

  // Getters
  List<VoiceInput> get voiceInputs => _voiceInputs;
  List<ImageData> get images => _images;
  bool get isRecording => _isRecording;
  bool get isProcessing => _isProcessing;
  String? get error => _error;

  // Start recording
  Future<void> startRecording() async {
    try {
      _setRecording(true);
      _error = null;
      // Implement actual recording logic with audio_record package
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  // Stop recording
  Future<void> stopRecording(String audioPath) async {
    try {
      _setRecording(false);
      _setProcessing(true);

      final voiceInput = VoiceInput(
        audioPath: audioPath,
        status: VoiceInputStatus.processing,
      );

      _voiceInputs.add(voiceInput);
      notifyListeners();

      // Simulate transcription
      await Future.delayed(const Duration(seconds: 2));

      final updated = voiceInput.copyWith(
        transcription: 'Sample transcription',
        status: VoiceInputStatus.completed,
      );

      final index = _voiceInputs.indexWhere((v) => v.id == voiceInput.id);
      if (index != -1) {
        _voiceInputs[index] = updated;
      }
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    } finally {
      _setProcessing(false);
    }
  }

  // Process image
  Future<void> processImage(String imagePath) async {
    try {
      _setProcessing(true);
      _error = null;

      final imageData = ImageData(imagePath: imagePath);

      _images.add(imageData);
      notifyListeners();

      // Simulate image analysis
      await Future.delayed(const Duration(seconds: 2));

      final updated = imageData.copyWith(
        description: 'Image analysis complete',
        detectedObjects: ['object1', 'object2'],
      );

      final index = _images.indexWhere((i) => i.id == imageData.id);
      if (index != -1) {
        _images[index] = updated;
      }
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    } finally {
      _setProcessing(false);
    }
  }

  void _setRecording(bool value) {
    _isRecording = value;
  }

  void _setProcessing(bool value) {
    _isProcessing = value;
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
