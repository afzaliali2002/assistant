class AppConstants {
  // API Keys (Users should add their own)
  static const String openaiApiKey = 'YOUR_OPENAI_API_KEY';
  static const String googleGeminiApiKey = 'YOUR_GOOGLE_GEMINI_API_KEY';
  static const String huggingFaceApiKey = 'YOUR_HUGGINGFACE_API_KEY';
  static const String anthropicApiKey = 'YOUR_ANTHROPIC_API_KEY';

  // API URLs
  static const String openaiBaseUrl = 'https://api.openai.com/v1';
  static const String googleGeminiUrl = 'https://generativelanguage.googleapis.com/v1beta/models';
  static const String huggingFaceUrl = 'https://huggingface.co/api';
  static const String anthropicBaseUrl = 'https://api.anthropic.com/v1';

  // App Settings
  static const String appName = 'AI Assistant';
  static const String appVersion = '1.0.0';
  static const int connectTimeout = 30000; // 30 seconds
  static const int receiveTimeout = 30000;

  // Database
  static const String dbName = 'assistant.db';
  static const int dbVersion = 1;

  // Preferences Keys
  static const String userIdKey = 'user_id';
  static const String authTokenKey = 'auth_token';
  static const String darkModeKey = 'dark_mode';
  static const String languageKey = 'language';
  static const String openaiKeyPreference = 'openai_key_pref';
  static const String geminiKeyPreference = 'gemini_key_pref';
  static const String huggingfaceKeyPreference = 'huggingface_key_pref';
  static const String anthropicKeyPreference = 'anthropic_key_pref';

  // Feature Flags
  static const bool enableOfflineMode = true;
  static const bool enableVoiceInput = true;
  static const bool enableImageProcessing = true;
  static const bool enableAutomation = true;
}
