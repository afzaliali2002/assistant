import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/services/storage_service.dart';
import 'features/automation/presentation/viewmodels/automation_viewmodel.dart';
import 'features/conversations/presentation/viewmodels/conversation_viewmodel.dart';
import 'features/content_creation/presentation/viewmodels/content_viewmodel.dart';
import 'features/knowledge/presentation/viewmodels/knowledge_viewmodel.dart';
import 'features/settings/presentation/viewmodels/settings_viewmodel.dart';
import 'features/task_management/presentation/viewmodels/task_viewmodel.dart';
import 'features/home/presentation/views/home_view.dart';
import 'features/user_profile/presentation/viewmodels/user_viewmodel.dart';
import 'features/voice_vision/presentation/viewmodels/voice_vision_viewmodel.dart';
import 'features/conversations/presentation/views/conversation_view.dart';
import 'features/assistant/presentation/views/assistant_view.dart';
import 'features/action/presentation/views/action_view.dart';
import 'features/content_creation/presentation/views/content_creation_view.dart';
import 'features/settings/presentation/views/settings_view.dart';
import 'features/onboarding/presentation/views/onboarding_view.dart';
import 'features/auth/presentation/views/login_view.dart';
import 'features/auth/presentation/views/signup_view.dart';
import 'features/auth/presentation/views/forgot_password_view.dart';
import 'features/user_profile/presentation/views/user_profile_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize local storage
  await StorageService().initialize();

  runApp(const AssistantApp());
}

class AssistantApp extends StatelessWidget {
  const AssistantApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TaskViewModel()),
        ChangeNotifierProvider(create: (_) => ConversationViewModel()),
        ChangeNotifierProvider(create: (_) => AutomationViewModel()),
        ChangeNotifierProvider(create: (_) => KnowledgeViewModel()),
        ChangeNotifierProvider(create: (_) => ContentCreationViewModel()),
        ChangeNotifierProvider(create: (_) => VoiceVisionViewModel()),
        ChangeNotifierProvider(create: (_) => UserProfileViewModel()),
        ChangeNotifierProvider(create: (_) => SettingsViewModel()),
      ],
      child: Consumer<SettingsViewModel>(
        builder: (context, settingsVM, _) {
          return MaterialApp(
            title: 'دستیار هوشمند',
            routes: {
              '/home': (context) => const HomeScreen(),
              '/onboarding': (context) => const OnboardingView(),
              '/login': (context) => const LoginView(),
              '/signup': (context) => const SignUpView(),
              '/forgot_password': (context) => const ForgotPasswordView(),
              '/profile': (context) => const UserProfileView(),
            },
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.blue,
                brightness: settingsVM.settings.darkMode
                    ? Brightness.dark
                    : Brightness.light,
              ),
              useMaterial3: true,
            ),
            darkTheme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.blue,
                brightness: Brightness.dark,
              ),
              useMaterial3: true,
            ),
            themeMode: settingsVM.settings.darkMode
              ? ThemeMode.dark
              : ThemeMode.light,
            // Start the app at the onboarding screen (temporary)
            initialRoute: '/onboarding',
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  late final List<Widget> _views;

  final List<String> _titles = [
    'Home',
    'Action',
    'Assistant',
    'Content',
    'Settings',
  ];

  @override
  void initState() {
    super.initState();
    // Initialize settings on app start
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SettingsViewModel>().loadSettings();
    });
    
    // Initialize views with the callback
    _views = [
      HomeView(onNavigateToTab: _navigateToTab),
      const ActionView(),
      const AssistantView(),
      const ContentCreationView(),
      const SettingsView(),
    ];
  }

  void _navigateToTab(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_selectedIndex]),
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: IconButton(
              onPressed: () => Navigator.of(context).pushNamed('/profile'),
              icon: const CircleAvatar(
                radius: 16,
                backgroundImage: AssetImage('assets/onborading/assistant.png'),
              ),
            ),
          ),
        ],
      ),
      body: _views[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.flash_on), label: 'Action'),
          NavigationDestination(icon: Icon(Icons.smart_toy), label: 'Assistant'),
          NavigationDestination(icon: Icon(Icons.create), label: 'Content'),
          NavigationDestination(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}
