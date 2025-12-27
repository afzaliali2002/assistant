import 'package:flutter/material.dart';
import '../../data/models/knowledge_model.dart';

class KnowledgeViewModel extends ChangeNotifier {
  final List<KnowledgeItem> _items = [];
  KnowledgeItem? _selectedItem;
  bool _isLoading = false;
  String? _error;
  String _searchQuery = '';

  // Getters
  List<KnowledgeItem> get items => _items;
  KnowledgeItem? get selectedItem => _selectedItem;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Search items
  List<KnowledgeItem> get searchResults {
    if (_searchQuery.isEmpty) return _items;
    return _items.where((item) {
      return item.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          item.content.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          item.tags.any(
            (tag) => tag.toLowerCase().contains(_searchQuery.toLowerCase()),
          );
    }).toList();
  }

  // Get by category
  List<KnowledgeItem> getByCategory(String category) {
    return _items.where((item) => item.category == category).toList();
  }

  // Get favorites
  List<KnowledgeItem> get favorites =>
      _items.where((item) => item.isFavorite).toList();

  // Select item
  void selectItem(KnowledgeItem item) {
    _selectedItem = item;
    notifyListeners();
  }

  // Create item
  Future<void> createItem(KnowledgeItem item) async {
    try {
      _setLoading(true);
      _error = null;
      await Future.delayed(const Duration(milliseconds: 300));
      _items.add(item);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  // Update item
  Future<void> updateItem(KnowledgeItem item) async {
    try {
      _setLoading(true);
      _error = null;
      final index = _items.indexWhere((i) => i.id == item.id);
      if (index != -1) {
        await Future.delayed(const Duration(milliseconds: 300));
        _items[index] = item;
        _selectedItem = item;
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  // Delete item
  Future<void> deleteItem(String itemId) async {
    try {
      _setLoading(true);
      _error = null;
      await Future.delayed(const Duration(milliseconds: 300));
      _items.removeWhere((i) => i.id == itemId);
      if (_selectedItem?.id == itemId) {
        _selectedItem = null;
      }
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  // Toggle favorite
  Future<void> toggleFavorite(String itemId) async {
    try {
      final item = _items.firstWhere((i) => i.id == itemId);
      await updateItem(item.copyWith(isFavorite: !item.isFavorite));
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  // Search
  void search(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  // Load items
  Future<void> loadItems() async {
    try {
      _setLoading(true);
      _error = null;
      await Future.delayed(const Duration(milliseconds: 500));
      // Load from database
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

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
