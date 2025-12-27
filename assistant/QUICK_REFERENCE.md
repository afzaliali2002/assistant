# ⚡ Quick Reference Guide - AI Assistant

## 🚀 30-Second Start

```bash
cd b:\assistant\assistant
flutter pub get
flutter run
```

---

## 📋 Key Files Cheat Sheet

| Need to... | Go to... |
|-----------|----------|
| Add Task | `task_viewmodel.dart` → `createTask()` |
| Send Message | `conversation_viewmodel.dart` → `sendMessage()` |
| Generate Content | `content_viewmodel.dart` → `generateContent()` |
| Change Settings | `settings_viewmodel.dart` → `updateSettings()` |
| Use AI | `ai_service.dart` → `AIServiceBase` |
| Save Data | `storage_service.dart` → `setString()` |
| Change UI | `main.dart` → edit `_views` list |
| Add API Key | `settings_view.dart` → settings dialog |

---

## 🎯 Common Code Patterns

### Using a ViewModel in View

```dart
Consumer<TaskViewModel>(
  builder: (context, viewModel, child) {
    if (viewModel.isLoading) {
      return const CircularProgressIndicator();
    }
    
    return ListView(
      itemCount: viewModel.tasks.length,
      itemBuilder: (_, index) => Text(viewModel.tasks[index].title),
    );
  },
)
```

### Creating Model

```dart
class MyModel {
  final String id;
  final String title;
  
  MyModel({
    String? id,
    required this.title,
  }) : id = id ?? const Uuid().v4();
  
  Map<String, dynamic> toMap() => {'id': id, 'title': title};
  
  factory MyModel.fromMap(Map<String, dynamic> map) =>
    MyModel(id: map['id'], title: map['title']);
}
```

### Creating ViewModel

```dart
class MyViewModel extends ChangeNotifier {
  List<MyModel> _items = [];
  
  List<MyModel> get items => _items;
  
  Future<void> addItem(MyModel item) async {
    _items.add(item);
    notifyListeners(); // Rebuild UI
  }
}
```

### Calling AI Service

```dart
final aiService = OpenAIService(apiKey: 'your-key');
final response = await aiService.generateText('Hello, AI!');
print(response);
```

### Saving to Storage

```dart
final storage = StorageService();
await storage.setString('user_name', 'John');
final name = storage.getString('user_name');
```

---

## 🔗 Data Flow Shortcuts

**Task Management:**
```
User Input → TaskViewModel.createTask() → _tasks.add() 
→ notifyListeners() → UI Rebuilds
```

**AI Conversation:**
```
User Message → ConversationViewModel.sendMessage() 
→ AIService.generateText() → API Call 
→ Parse Response → Add to messages → notifyListeners() → Display
```

**Save Settings:**
```
User Changes Setting → SettingsViewModel.updateSettings() 
→ StorageService.setString() → SharedPreferences 
→ notifyListeners() → UI Updates
```

---

## 📱 Navigation Map

```
HomeScreen (index 0-3)
├─ Index 0: TaskManagementView
├─ Index 1: ConversationView
├─ Index 2: ContentCreationView
└─ Index 3: SettingsView
```

---

## 🤖 AI Services Quick Access

```dart
// OpenAI
OpenAIService(apiKey: 'sk-...')
  .generateText(prompt)

// Google Gemini
GoogleGeminiService(apiKey: 'YOUR_KEY')
  .generateText(prompt)

// HuggingFace
HuggingFaceService(apiKey: 'hf_...')
  .generateText(prompt)

// Anthropic
AnthropicService(apiKey: 'sk-ant-...')
  .generateText(prompt)
```

---

## 🗄️ Database Operations

```dart
// Get database
final db = await DatabaseService().database;

// Insert
await db.insert('tasks', taskMap);

// Query
final results = await db.query('tasks');

// Update
await db.update('tasks', taskMap, where: 'id = ?', whereArgs: [id]);

// Delete
await db.delete('tasks', where: 'id = ?', whereArgs: [id]);
```

---

## 🎨 Add New Feature in 5 Steps

1. **Create folders:**
   ```bash
   mkdir -p lib/features/myfeature/data/models
   mkdir -p lib/features/myfeature/presentation/viewmodels
   mkdir -p lib/features/myfeature/presentation/views
   ```

2. **Create model:**
   ```dart
   // lib/features/myfeature/data/models/mymodel.dart
   class MyModel {
     final String id;
     // ... fields and methods
   }
   ```

3. **Create ViewModel:**
   ```dart
   // lib/features/myfeature/presentation/viewmodels/myviewmodel.dart
   class MyViewModel extends ChangeNotifier {
     // ... state and methods
   }
   ```

4. **Create View:**
   ```dart
   // lib/features/myfeature/presentation/views/myview.dart
   class MyView extends StatefulWidget { ... }
   ```

5. **Add to main.dart:**
   ```dart
   ChangeNotifierProvider(create: (_) => MyViewModel()),
   // And add to navigation
   ```

---

## 🔍 Debug Tips

| Problem | Solution |
|---------|----------|
| UI not updating | Check if `notifyListeners()` was called |
| ViewModel not found | Add to `MultiProvider` in main.dart |
| API not working | Check API key in settings or app_constants.dart |
| Database empty | Run `flutter clean` then `flutter pub get` |
| Import error | Check file path is correct |

---

## ⚙️ Configuration Checklist

- [ ] Add API keys to settings
- [ ] Set default AI model
- [ ] Configure language preference
- [ ] Test each AI service
- [ ] Verify database creation
- [ ] Check SharedPreferences saving
- [ ] Test navigation between screens

---

## 📚 File Locations Quick Ref

```
Core Services:     lib/core/services/
Models:            lib/features/*/data/models/
ViewModels:        lib/features/*/presentation/viewmodels/
Views:             lib/features/*/presentation/views/
Constants:         lib/core/constants/
Utils:             lib/core/utils/
Main App:          lib/main.dart
```

---

## 🎯 Testing Each Feature

### 1. Tasks
- Tap +, Create task
- Check list updates
- Mark as complete
- Delete task

### 2. Conversations
- Click "Start Conversation"
- Type message
- Check AI response
- Verify message appears

### 3. Content
- Enter prompt
- Select type
- Click Generate
- Check output

### 4. Settings
- Toggle Dark Mode
- Change Language
- Add API Key
- Verify it saves

---

## 💡 Pro Tips

1. **Use Selector for performance:**
   ```dart
   Selector<VM, int>(
     selector: (_, vm) => vm.items.length,
     builder: (_, count, __) => Text('$count items'),
   )
   ```

2. **Watch in terminal:**
   ```bash
   flutter run -v  # Verbose logging
   ```

3. **Format code:**
   ```bash
   flutter format lib/
   ```

4. **Analyze code quality:**
   ```bash
   flutter analyze
   ```

5. **View widget tree:**
   Flutter DevTools → Timeline/Widget Inspector

---

## 🐛 Common Issues & Fixes

**Issue:** `Provider not found`
```
✅ Check imports
✅ Verify in MultiProvider list
✅ Restart hot reload
```

**Issue:** `API returns 401`
```
✅ Verify API key
✅ Check expiration
✅ Re-add in settings
```

**Issue:** `Database locked`
```
✅ Run flutter clean
✅ Delete build/
✅ Run pub get again
```

**Issue:** `UI doesn't update`
```
✅ Call notifyListeners()
✅ Use Consumer/Selector
✅ Check ChangeNotifier extends
```

---

## 📊 Performance Tips

- ✅ Use `const` constructors
- ✅ Use `Consumer` only where needed
- ✅ Implement `shouldRebuild()` if needed
- ✅ Lazy load lists with pagination
- ✅ Cache API responses
- ✅ Use `Selector` for specific properties

---

## 🔐 Security Quick Check

- [ ] API keys not in git
- [ ] Use HTTPS for all APIs
- [ ] Validate user input
- [ ] Encrypt sensitive data
- [ ] Use SharedPreferences for tokens
- [ ] Handle errors gracefully

---

## 📞 Support Resources

| Need | Go to |
|------|-------|
| Flutter Docs | https://flutter.dev |
| Provider Docs | https://pub.dev/packages/provider |
| OpenAI | https://platform.openai.com/docs |
| Gemini | https://ai.google.dev |
| Claude | https://docs.anthropic.com |
| HuggingFace | https://huggingface.co/docs |

---

## ✅ Pre-Deployment Checklist

- [ ] All AI services tested
- [ ] Database working
- [ ] Navigation complete
- [ ] Error handling in place
- [ ] API keys configured
- [ ] No debug logs
- [ ] Release build tested
- [ ] Icons & branding updated

---

## 🎉 Quick Build Commands

```bash
# Run
flutter run

# Release build
flutter build apk --release

# Web build
flutter build web

# Desktop (Windows)
flutter build windows --release

# iOS
flutter build ipa --release

# Android App Bundle
flutter build appbundle --release
```

---

**Updated:** December 2025 | **Version:** 1.0.0 | **Status:** ✅ Ready
