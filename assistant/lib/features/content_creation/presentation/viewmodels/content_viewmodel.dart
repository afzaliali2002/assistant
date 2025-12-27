import 'package:flutter/material.dart';
import '../../data/models/content_model.dart';
import '../../data/content_repository.dart';
import '../../../../core/services/ai_service.dart';

class ContentCreationViewModel extends ChangeNotifier {
  final List<Content> _contents = [];
  Content? _selectedContent;
  bool _isLoading = false;
  bool _isGenerating = false;
  String? _error;
  AIServiceBase? _aiService;
  final ContentRepository _repository = ContentRepository();

  ContentCreationViewModel() {
    loadContents();
  }

  // Getters
  List<Content> get contents => _contents;
  Content? get selectedContent => _selectedContent;
  bool get isLoading => _isLoading;
  bool get isGenerating => _isGenerating;
  String? get error => _error;

  // Get published content
  List<Content> get publishedContents =>
      _contents.where((c) => c.isPublished).toList();

  // Get by type
  List<Content> getByType(ContentType type) {
    return _contents.where((c) => c.type == type).toList();
  }

  // Set AI Service
  void setAIService(AIServiceBase service) {
    _aiService = service;
  }

  // Generate content
  Future<void> generateContent({
    required String prompt,
    required ContentType type,
    required List<String> keywords,
  }) async {
    try {
      _setGenerating(true);
      _error = null;

      if (_aiService == null) {
        throw Exception('AI Service not initialized');
      }

      final content = await _aiService!.generateText(prompt);

      final newContent = Content(
        title: 'Generated ${type.name}',
        body: content,
        type: type,
        keywords: keywords,
      );

      _contents.add(newContent);
      _selectedContent = newContent;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    } finally {
      _setGenerating(false);
    }
  }

  // Create content
  Future<void> createContent(Content content) async {
    try {
      _setLoading(true);
      _error = null;
      await _repository.addContent(content);
      _contents.add(content);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  // Update content
  Future<void> updateContent(Content content) async {
    try {
      _setLoading(true);
      _error = null;
      final index = _contents.indexWhere((c) => c.id == content.id);
      if (index != -1) {
        await _repository.updateContent(content);
        _contents[index] = content;
        _selectedContent = content;
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  // Publish content
  Future<void> publishContent(String contentId) async {
    try {
      final content = _contents.firstWhere((c) => c.id == contentId);
      await updateContent(content.copyWith(isPublished: true));
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  // Delete content
  Future<void> deleteContent(String contentId) async {
    try {
      _setLoading(true);
      _error = null;
      await _repository.deleteContent(contentId);
      _contents.removeWhere((c) => c.id == contentId);
      if (_selectedContent?.id == contentId) {
        _selectedContent = null;
      }
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  // Load contents
  Future<void> loadContents() async {
    try {
      _setLoading(true);
      _error = null;
      final loaded = await _repository.getAllContent();
      _contents.clear();
      _contents.addAll(loaded);
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

  void _setGenerating(bool value) {
    _isGenerating = value;
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
