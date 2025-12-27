import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/services/storage_service.dart';
import 'features/automation/presentation/viewmodels/automation_viewmodel.dart';
import 'features/conversations/presentation/viewmodels/conversation_viewmodel.dart';
import 'features/content_creation/presentation/viewmodels/content_viewmodel.dart';
import 'features/knowledge/presentation/viewmodels/knowledge_viewmodel.dart';
import 'features/settings/presentation/viewmodels/settings_viewmodel.dart';
import 'features/task_management/presentation/viewmodels/task_viewmodel.dart';
import 'features/task_management/presentation/views/task_management_view.dart';
import 'features/user_profile/presentation/viewmodels/user_viewmodel.dart';
import 'features/voice_vision/presentation/viewmodels/voice_vision_viewmodel.dart';
import 'features/conversations/presentation/views/conversation_view.dart';
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
            // Start the app at the login screen
            initialRoute: '/login',
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

  final List<Widget> _views = [
    const TaskManagementView(),
    const ConversationView(),
    const ContentCreationView(),
    const SettingsView(),
  ];

  final List<String> _titles = [
    'Home',
    'Action',
    'Assistant',
    'Activity',
  ];

  @override
  void initState() {
    super.initState();
    // Initialize settings on app start
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SettingsViewModel>().loadSettings();
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
                child: Icon(Icons.person, size: 18),
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
          NavigationDestination(icon: Icon(Icons.notifications), label: 'Activity'),
        ],
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: .center,
          children: [
            const Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class TaskManagementView extends StatelessWidget {
  const TaskManagementView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks'),
        elevation: 0,
      ),
      body: Consumer<TaskViewModel>(
        builder: (context, viewModel, _) {
          if (viewModel.tasks.isEmpty) {
            return const Center(
              child: Text('No tasks yet'),
            );
          }

          return ListView.builder(
            itemCount: viewModel.tasks.length,
            itemBuilder: (context, index) {
              final task = viewModel.tasks[index];
              return ListTile(
                title: Text(task.title),
                subtitle: task.description != null ? Text(task.description!) : null,
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => viewModel.deleteTask(task.id!),
                ),
              );
            },
          );
        },
      ),
      // FAB intentionally removed here to avoid duplicate/recursive navigation
    );
  }
}
