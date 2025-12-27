# 🏗️ AI Assistant - MVVM Architecture Diagram

## Complete Architecture Overview

```
┌─────────────────────────────────────────────────────────────────┐
│                      FLUTTER APPLICATION                         │
│                      (lib/main.dart)                             │
│                   [HomeScreen with Navigation]                   │
└─────────────────────────────────────────────────────────────────┘
                              │
                ┌─────────────┼─────────────┐
                │             │             │
                ▼             ▼             ▼
        ┌─────────────┐ ┌──────────────┐ ┌──────────┐
        │   Provider  │ │  Consumer    │ │ Listeners│
        │  (State     │ │  (UI Rebuild)│ │  (Watch) │
        │ Management) │ │              │ │          │
        └─────────────┘ └──────────────┘ └──────────┘
                │
                ▼
┌─────────────────────────────────────────────────────────────────┐
│                   PRESENTATION LAYER                             │
│                   (Views & ViewModels)                           │
├─────────────────────────────────────────────────────────────────┤
│                                                                   │
│  ┌─────────────────┐  ┌──────────────────┐  ┌─────────────────┐ │
│  │   Task View     │  │Conversation View │  │Content Creation │ │
│  │                 │  │                  │  │      View       │ │
│  └────────┬────────┘  └────────┬─────────┘  └────────┬────────┘ │
│           │                    │                      │           │
│           ▼                    ▼                      ▼           │
│  ┌─────────────────┐  ┌──────────────────┐  ┌─────────────────┐ │
│  │ TaskViewModel   │  │ConversationVM    │  │ContentViewModel │ │
│  │ ├─ tasks: []    │  │ ├─ conversations │  │ ├─ contents: []  │ │
│  │ ├─ selected     │  │ ├─ currentConv   │  │ ├─ generating   │ │
│  │ ├─ isLoading    │  │ ├─ isGenerating  │  │ ├─ isPublished  │ │
│  │ ├─ error        │  │ ├─ error         │  │ ├─ error        │ │
│  │ └─ methods()    │  │ └─ methods()     │  │ └─ methods()    │ │
│  └────────┬────────┘  └────────┬─────────┘  └────────┬────────┘ │
│           │                    │                      │           │
│  [Similar pattern for Automation, Knowledge, Settings...]         │
│                                                                   │
└────────────────────────────────┬──────────────────────────────────┘
                                 │ Uses
                                 ▼
┌─────────────────────────────────────────────────────────────────┐
│                    DATA LAYER (Models)                           │
│                                                                  │
│ ┌──────────────┐ ┌──────────────┐ ┌──────────────┐              │
│ │ Task         │ │ Conversation │ │ Content      │              │
│ │ ├─ id        │ │ ├─ id        │ │ ├─ id        │              │
│ │ ├─ title     │ │ ├─ title     │ │ ├─ title     │              │
│ │ ├─ status    │ │ ├─ messages  │ │ ├─ body      │              │
│ │ └─ methods() │ │ └─ methods() │ │ └─ methods() │              │
│ │              │ │              │ │              │              │
│ └──────────────┘ └──────────────┘ └──────────────┘              │
│ [Automation, Knowledge, User, Settings Models...]              │
│                                                                  │
└─────────────┬──────────────────────────────┬────────────────────┘
              │                              │
              ▼                              ▼
┌──────────────────────────────────┐  ┌──────────────────────────┐
│      CORE SERVICES LAYER         │  │   EXTERNAL SERVICES      │
├──────────────────────────────────┤  ├──────────────────────────┤
│ ┌─────────────────────────────┐  │  │ ┌────────────────────┐   │
│ │  AI Service (ai_service)    │  │  │ │  OpenAI API        │   │
│ │ ├─ OpenAIService            │  │  │ │  (gpt-3.5-turbo)   │   │
│ │ ├─ GoogleGeminiService      │  │  │ └────────────────────┘   │
│ │ ├─ HuggingFaceService       │  │  │                          │
│ │ └─ AnthropicService         │  │  │ ┌────────────────────┐   │
│ │   ├─ generateText()         │  │  │ │ Google Gemini API  │   │
│ │   ├─ analyzeImage()         │  │  │ │ (gemini-pro)       │   │
│ │   └─ generateCode()         │  │  │ └────────────────────┘   │
│ └─────────────────────────────┘  │  │                          │
│                                   │  │ ┌────────────────────┐   │
│ ┌─────────────────────────────┐  │  │ │ HuggingFace API    │   │
│ │  Database Service           │  │  │ │ (Mistral-7B)       │   │
│ │  (database_service.dart)    │  │  │ └────────────────────┘   │
│ │ ├─ _initDatabase()          │  │  │                          │
│ │ ├─ _createTables()          │  │  │ ┌────────────────────┐   │
│ │ └─ SQLite Operations        │  │  │ │ Anthropic Claude   │   │
│ └─────────────────────────────┘  │  │ │ (claude-3-sonnet)  │   │
│                                   │  │ └────────────────────┘   │
│ ┌─────────────────────────────┐  │  │                          │
│ │  Storage Service            │  │  │ ┌────────────────────┐   │
│ │  (storage_service.dart)     │  │  │ │ Firebase (optional)│   │
│ │ ├─ setString()              │  │  │ └────────────────────┘   │
│ │ ├─ getString()              │  │  │                          │
│ │ └─ SharedPreferences ops    │  │  │ ┌────────────────────┐   │
│ └─────────────────────────────┘  │  │ │ Audio Recording    │   │
│                                   │  │ │ Image Picker       │   │
│ ┌─────────────────────────────┐  │  │ └────────────────────┘   │
│ │  Utilities                  │  │  │                          │
│ ├─ logger.dart                │  │  │                          │
│ ├─ date_formatter.dart        │  │  │                          │
│ ├─ validators.dart            │  │  │                          │
│ └─ Constants & Error Messages │  │  │                          │
└──────────────────────────────────┘  └──────────────────────────┘
              │
              ▼
┌────────────────────────────────────────────────────────────┐
│            PERSISTENT STORAGE                              │
├────────────────────────────────────────────────────────────┤
│                                                             │
│  ┌───────────────────┐  ┌──────────────────────┐          │
│  │ SQLite Database   │  │ SharedPreferences    │          │
│  │ (Local Data)      │  │ (App Settings)       │          │
│  ├───────────────────┤  ├──────────────────────┤          │
│  │ • tasks           │  │ • user_id            │          │
│  │ • conversations   │  │ • auth_token         │          │
│  │ • messages        │  │ • dark_mode          │          │
│  │ • automations     │  │ • language           │          │
│  │ • knowledge_base  │  │ • api_keys           │          │
│  │ • user_settings   │  │ • preferences        │          │
│  └───────────────────┘  └──────────────────────┘          │
└────────────────────────────────────────────────────────────┘
```

---

## Data Flow Example: Creating a Task

```
User Input (UI)
    │
    ▼
[TaskManagementView]
    │ User taps "Create Task"
    ▼
[OnPressed callback]
    │
    ▼
[TaskViewModel.createTask(task)]
    │ ├─ Set _isLoading = true
    │ ├─ Simulate API call (Optional)
    │ ├─ Add to _tasks list
    │ └─ notifyListeners()
    │
    ▼
[Consumer rebuilds view]
    │
    ▼
[New task appears in ListView]
    │
    ▼
[Save to Database (optional)]
    └─ DatabaseService.insert()
```

---

## Data Flow Example: AI Conversation

```
User Input (Chat Message)
    │
    ▼
[ConversationView - TextField]
    │
    ▼
[Send Message Button]
    │
    ▼
[ConversationViewModel.sendMessage(content)]
    │
    ├─ Create Message object
    ├─ Add to _currentConversation.messages
    ├─ notifyListeners() → UI updates
    │
    ▼
[AI Response Generation]
    │
    ├─ Check _aiService (OpenAI, Gemini, etc.)
    ├─ Call generateText(userMessage)
    │
    ▼
[External API Call]
    │
    ├─ OpenAI: https://api.openai.com/v1/chat/completions
    ├─ Gemini: https://generativelanguage.googleapis.com/...
    ├─ HuggingFace: https://huggingface.co/api/...
    └─ Anthropic: https://api.anthropic.com/v1/messages
    │
    ▼
[Parse Response]
    │
    ▼
[Create Assistant Message]
    │
    ├─ Add to _currentConversation.messages
    ├─ notifyListeners()
    │
    ▼
[Consumer rebuilds view]
    │
    ▼
[Both messages displayed in chat]
    │
    ▼
[Save to Database]
    └─ DatabaseService.insert(message)
```

---

## MVVM Pattern Structure

```
┌─────────────────────────────────────────────────────────┐
│                      VIEW (UI)                          │
│                                                         │
│  ┌────────────────────────────────────────────────┐   │
│  │ TaskManagementView (StatefulWidget)            │   │
│  │                                                │   │
│  │  build() {                                     │   │
│  │    Consumer<TaskViewModel>(                   │   │
│  │      builder: (context, vm, child) {          │   │
│  │        // Rebuild when vm notifies            │   │
│  │        ListView(                              │   │
│  │          itemBuilder: (context, index) =>     │   │
│  │            TaskCard(task: vm.tasks[index])    │   │
│  │        )                                       │   │
│  │      }                                         │   │
│  │    )                                           │   │
│  │  }                                             │   │
│  │                                                │   │
│  │  User Events:                                  │   │
│  │  ├─ onPressed → vm.createTask()              │   │
│  │  ├─ onTap → vm.selectTask()                  │   │
│  │  └─ onSlide → vm.deleteTask()                │   │
│  └────────────────────────────────────────────────┘   │
│                         ▲                              │
│                         │ Listens & Rebuilds          │
│                         │                              │
└─────────────────────────┼──────────────────────────────┘
                          │
        ┌─────────────────┘
        │
        ▼
┌─────────────────────────────────────────────────────────┐
│               VIEWMODEL (Business Logic)                │
│                                                         │
│  ┌────────────────────────────────────────────────┐   │
│  │ TaskViewModel extends ChangeNotifier {         │   │
│  │                                                │   │
│  │  // State                                      │   │
│  │  List<Task> _tasks = [];                      │   │
│  │  Task? _selectedTask;                         │   │
│  │  bool _isLoading = false;                     │   │
│  │  String? _error;                              │   │
│  │                                                │   │
│  │  // Getters                                    │   │
│  │  List<Task> get tasks => _tasks;              │   │
│  │  bool get isLoading => _isLoading;            │   │
│  │                                                │   │
│  │  // Business Logic Methods                    │   │
│  │  Future<void> createTask(Task task) async {   │   │
│  │    _isLoading = true;                         │   │
│  │    // Validation, API calls, DB operations   │   │
│  │    _tasks.add(task);                         │   │
│  │    notifyListeners(); // Signal UI to rebuild │   │
│  │  }                                             │   │
│  │                                                │   │
│  │  Future<void> updateTask(Task task) async {   │   │
│  │    // Update logic                            │   │
│  │    notifyListeners();                         │   │
│  │  }                                             │   │
│  │                                                │   │
│  │  Future<void> deleteTask(String id) async {   │   │
│  │    // Delete logic                            │   │
│  │    notifyListeners();                         │   │
│  │  }                                             │   │
│  │ }                                              │   │
│  └────────────────────────────────────────────────┘   │
│                         ▲                              │
│                         │ Uses Models & Services       │
│                         │                              │
└─────────────────────────┼──────────────────────────────┘
                          │
        ┌─────────────────┼─────────────┐
        │                 │             │
        ▼                 ▼             ▼
┌──────────────┐  ┌──────────────┐  ┌──────────────┐
│ MODEL        │  │ DATABASE     │  │ STORAGE      │
│ (Data Class) │  │ SERVICE      │  │ SERVICE      │
│              │  │              │  │              │
│ Task {       │  │ insert()     │  │ saveString() │
│  - id        │  │ update()     │  │ getString()  │
│  - title     │  │ delete()     │  │              │
│  - status    │  │ query()      │  │              │
│  - ...       │  │              │  │              │
│ }            │  │              │  │              │
└──────────────┘  └──────────────┘  └──────────────┘
```

---

## Feature Module Internal Structure

```
feature_name/
│
├── data/                          ← Data Layer
│   ├── models/
│   │   └── task_model.dart        ← Pure Data Classes
│   │
│   ├── repositories/               ← (Optional: Abstract interfaces)
│   │   └── task_repository.dart
│   │
│   └── datasources/               ← (Optional: API/DB access)
│       ├── remote_datasource.dart
│       └── local_datasource.dart
│
└── presentation/                  ← Presentation Layer
    ├── viewmodels/
    │   └── task_viewmodel.dart    ← Business Logic & State
    │
    ├── views/
    │   └── task_view.dart         ← UI Widgets
    │
    ├── widgets/                   ← (Optional: Feature widgets)
    │   ├── task_card.dart
    │   └── task_list.dart
    │
    └── pages/                     ← (Optional: Full pages)
        └── task_detail_page.dart
```

---

## Provider Setup Flow

```
main.dart
    │
    ├─ WidgetsFlutterBinding.ensureInitialized()
    ├─ Initialize StorageService
    │
    ▼
runApp(AssistantApp)
    │
    ▼
MultiProvider (Dependency Declaration)
    │
    ├─ ChangeNotifierProvider<TaskViewModel>()
    ├─ ChangeNotifierProvider<ConversationViewModel>()
    ├─ ChangeNotifierProvider<ContentViewModel>()
    ├─ ChangeNotifierProvider<SettingsViewModel>()
    └─ ... (other ViewModels)
    │
    ▼
Consumer<SettingsViewModel> (Read Settings)
    │
    ▼
MaterialApp (Apply Theme)
    │
    ▼
HomeScreen (Navigation)
    │
    ├─ Consumer<TaskViewModel> → TaskView
    ├─ Consumer<ConversationViewModel> → ConversationView
    ├─ Consumer<ContentViewModel> → ContentView
    └─ Consumer<SettingsViewModel> → SettingsView
```

---

## State Management Flow

```
User Action (Tap, Type, Swipe)
        │
        ▼
[View] calls ViewModel.method()
        │
        ▼
[ViewModel] processes:
        │
        ├─ Set _isLoading = true
        ├─ Validate input
        ├─ Call DatabaseService / APIService
        ├─ Update _items list
        ├─ Set _isLoading = false
        └─ Call notifyListeners()
        │
        ▼
[Provider] notifies all Consumer/Listener widgets
        │
        ▼
[Views] rebuild with new state
        │
        ├─ if (_isLoading) show spinner
        ├─ if (_error) show error message
        └─ else show data from ViewModel
        │
        ▼
[UI Update Visible to User]
```

---

## API Integration Layer

```
ViewModel.method()
    │
    ├─ Get AIService instance
    │   └─ openaiService / geminiService / etc.
    │
    ▼
AIService.generateText(prompt)
    │
    ├─ Prepare request with API key
    ├─ Add headers & authentication
    │
    ▼
Dio / HTTP Client
    │
    ├─ Make HTTP request to:
    │   ├─ https://api.openai.com/v1/chat/completions
    │   ├─ https://generativelanguage.googleapis.com/...
    │   ├─ https://huggingface.co/api/...
    │   └─ https://api.anthropic.com/v1/messages
    │
    ▼
[External AI Service] (Cloud)
    │
    ├─ Process request
    └─ Return JSON response
    │
    ▼
Parse Response
    │
    ▼
Return result to ViewModel
    │
    ▼
ViewModel updates state
    │
    ▼
notifyListeners() → View rebuilds
```

---

## Database Schema Relationship

```
conversations
    ├─ id (PK)
    ├─ title
    └─ createdAt
         │
         ├─── (1:N) ───► messages
                         ├─ id (PK)
                         ├─ conversationId (FK)
                         ├─ content
                         ├─ role
                         └─ createdAt

tasks
    ├─ id (PK)
    ├─ title
    ├─ status
    └─ priority

automations
    ├─ id (PK)
    ├─ name
    ├─ trigger
    └─ action

knowledge_base
    ├─ id (PK)
    ├─ title
    ├─ content
    └─ category

user_settings
    ├─ id (PK)
    ├─ darkMode
    ├─ language
    └─ defaultAiModel
```

---

## Widget Tree Structure

```
AssistantApp
    │
    ├─ MultiProvider
    │
    └─ MaterialApp
        │
        └─ HomeScreen
            │
            └─ Scaffold
                ├─ AppBar (Variable content)
                │
                ├─ Body
                │   └─ Consumer<ViewModel>
                │       └─ View Widget
                │           ├─ if loading → CircularProgressIndicator
                │           ├─ if error → ErrorWidget
                │           └─ else → ContentWidget
                │
                └─ BottomNavigationBar
                    ├─ Tasks
                    ├─ Conversations
                    ├─ Content
                    └─ Settings
```

---

## Performance Optimization Flow

```
Consumer<ViewModel>
    │
    └─ Only rebuilds when ViewModel.notifyListeners() called
    │
    ├─ Granular: Consumer only for changing parts
    ├─ Optimization: Selector<ViewModel, int> for specific properties
    └─ Avoid: Watching entire ViewModel if only 1 property changes

Example:
✅ Consumer<TaskViewModel>(                (Rebuilds on any change)
    builder: (context, vm, child) {
        return ListView(...);
    }
)

✅ Selector<TaskViewModel, int>(            (Only rebuilds if count changes)
    selector: (_, vm) => vm.tasks.length,
    builder: (context, count, child) {
        return Text('Tasks: $count');
    }
)
```

---

## Security & Data Flow

```
User Input
    │
    ├─ [Validator] checks input
    │
    ├─ [ViewModel] validates again
    │
    ├─ [DatabaseService/StorageService]
    │   └─ Sanitizes & encodes data
    │
    ├─ [Encryption] for sensitive data
    │
    └─ [Database/SharedPreferences]
        └─ Stored securely locally

API Calls
    │
    ├─ [Dio] handles HTTPS
    │
    ├─ [Authentication headers] with API keys
    │
    ├─ [Error handling] for failed requests
    │
    └─ [Response parsing] with validation
```

---

**This architecture ensures:**
- ✅ Scalability
- ✅ Testability
- ✅ Code reusability
- ✅ Clear separation of concerns
- ✅ Easy maintenance
- ✅ Team collaboration
- ✅ Performance optimization
