import 'package:get_it/get_it.dart';
import '../services/database_service.dart';
import '../services/storage_service.dart';
import '../../features/automation/presentation/viewmodels/automation_viewmodel.dart';
import '../../features/conversations/presentation/viewmodels/conversation_viewmodel.dart';
import '../../features/content_creation/presentation/viewmodels/content_viewmodel.dart';
import '../../features/knowledge/presentation/viewmodels/knowledge_viewmodel.dart';
import '../../features/settings/presentation/viewmodels/settings_viewmodel.dart';
import '../../features/task_management/presentation/viewmodels/task_viewmodel.dart';
import '../../features/user_profile/presentation/viewmodels/user_viewmodel.dart';
import '../../features/voice_vision/presentation/viewmodels/voice_vision_viewmodel.dart';

/// Service Locator - Dependency Injection
final GetIt getIt = GetIt.instance;

/// Service Locator - Dependency Injection
class ServiceLocator {
  static void setupServices() {
    // Core Services
    getIt.registerSingleton<StorageService>(StorageService());
    getIt.registerSingleton<DatabaseService>(DatabaseService());

    // ViewModels
    getIt.registerSingleton<TaskViewModel>(TaskViewModel());
    getIt.registerSingleton<ConversationViewModel>(ConversationViewModel());
    getIt.registerSingleton<AutomationViewModel>(AutomationViewModel());
    getIt.registerSingleton<KnowledgeViewModel>(KnowledgeViewModel());
    getIt.registerSingleton<ContentCreationViewModel>(ContentCreationViewModel());
    getIt.registerSingleton<VoiceVisionViewModel>(VoiceVisionViewModel());
    getIt.registerSingleton<UserProfileViewModel>(UserProfileViewModel());
    getIt.registerSingleton<SettingsViewModel>(SettingsViewModel());
  }

  static T get<T extends Object>() {
    return getIt<T>();
  }
}

// Alternative: Using get_it package
// import 'package:get_it/get_it.dart';
// final getIt = GetIt.instance;
