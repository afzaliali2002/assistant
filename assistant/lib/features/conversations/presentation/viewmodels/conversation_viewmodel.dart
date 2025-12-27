import 'package:flutter/material.dart';
import '../../data/models/conversation_model.dart';
import '../../data/conversation_repository.dart';
import '../../../../core/services/ai_service.dart';

class ConversationViewModel extends ChangeNotifier {
  final List<Conversation> _conversations = [];
  Conversation? _currentConversation;
  bool _isLoading = false;
  bool _isGenerating = false;
  String? _error;
  AIServiceBase? _aiService;
  final ConversationRepository _repository = ConversationRepository();

  ConversationViewModel() {
    loadConversations();
  }

  // Getters
  List<Conversation> get conversations => _conversations;
  Conversation? get currentConversation => _currentConversation;
  bool get isLoading => _isLoading;
  bool get isGenerating => _isGenerating;
  String? get error => _error;
  List<Message> get currentMessages => _currentConversation?.messages ?? [];

  // Set AI Service
  void setAIService(AIServiceBase service) {
    _aiService = service;
  }

  // Create new conversation
  Future<void> createConversation(String title, {String? description}) async {
    try {
      _setLoading(true);
      _error = null;

      final conversation = Conversation(title: title, description: description);
      await _repository.addConversation(conversation);
      _conversations.add(conversation);
      _currentConversation = conversation;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  // Send message
  Future<void> sendMessage(String content) async {
    if (_currentConversation == null) return;

    try {
      _setGenerating(true);
      _error = null;

      // Add user message
      final userMessage = Message(
        conversationId: _currentConversation!.id,
        content: content,
        role: 'user',
      );

      var updatedMessages = [..._currentConversation!.messages, userMessage];
      _currentConversation = _currentConversation!.copyWith(
        messages: updatedMessages,
      );
      notifyListeners();

      // Generate AI response (mock for now)
      await Future.delayed(const Duration(milliseconds: 800));
      final mockResponse =
          'Echo: $content'; // Mock AI response without backend

      final aiMessage = Message(
        conversationId: _currentConversation!.id,
        content: mockResponse,
        role: 'assistant',
        aiModel: _currentConversation!.aiModel,
      );

      updatedMessages = [..._currentConversation!.messages, aiMessage];
      _currentConversation = _currentConversation!.copyWith(
        messages: updatedMessages,
      );

      // Persist updated conversation
      await _repository.updateConversation(_currentConversation!);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    } finally {
      _setGenerating(false);
    }
  }

  // Load conversations
  Future<void> loadConversations() async {
    try {
      _setLoading(true);
      _error = null;
      final loaded = await _repository.getAllConversations();
      _conversations.clear();
      _conversations.addAll(loaded);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  // Select conversation
  void selectConversation(Conversation conversation) {
    _currentConversation = conversation;
    notifyListeners();
  }

  // Delete conversation
  Future<void> deleteConversation(String id) async {
    try {
      _setLoading(true);
      _error = null;
      await _repository.deleteConversation(id);
      _conversations.removeWhere((c) => c.id == id);
      if (_currentConversation?.id == id) {
        _currentConversation = null;
      }
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
