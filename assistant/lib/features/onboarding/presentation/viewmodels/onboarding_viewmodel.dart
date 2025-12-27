import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingContent {
  final String title;
  final String description;
  final String imagePath;

  OnboardingContent({
    required this.title,
    required this.description,
    required this.imagePath,
  });
}

class OnboardingViewModel extends ChangeNotifier {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingContent> _pages = [
    OnboardingContent(
      title: "Welcome to\nYour Smart Assistant",
      description: "Your AI helper to guide and assist you.",
      imagePath: "assets/onborading/assistant.png",
    ),
    OnboardingContent(
      title: "Stay Informed\n& In Control",
      description: "Get notifications & smart suggestions,\nwith your approval.",
      imagePath: "assets/onborading/notification.png",
    ),
    OnboardingContent(
      title: "Boost Your\nProductivity",
      description: "Manage tasks, set reminders,\nand get helpful advice.",
      imagePath: "assets/onborading/productivity.png",
    ),
    OnboardingContent(
      title: "Your Privacy,\nYour Control",
      description: "You decide what the assistant can access.",
      imagePath: "assets/onborading/privacy.png",
    ),
  ];

  PageController get pageController => _pageController;
  int get currentPage => _currentPage;
  List<OnboardingContent> get pages => _pages;
  bool get isLastPage => _currentPage == _pages.length - 1;

  void onPageChanged(int index) {
    _currentPage = index;
    notifyListeners();
  }

  void nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> completeOnboarding(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('has_completed_onboarding', true);
    
    // Schedule navigation after the current frame to avoid Navigator being locked
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (context.mounted) {
        // Navigate to main app - Ensure this route is defined in main.dart
        Navigator.of(context).pushReplacementNamed('/home');
      }
    });
  }
}
