import 'package:dio/dio.dart';
import '../constants/app_constants.dart';

abstract class AIServiceBase {
  Future<String> generateText(String prompt);
  Future<String> analyzeImage(String imagePath);
  Future<String> generateCode(String description);
}

class OpenAIService extends AIServiceBase {
  final String apiKey;
  late final Dio _dio;

  OpenAIService({String? apiKey})
    : apiKey = apiKey ?? AppConstants.openaiApiKey {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppConstants.openaiBaseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Authorization': 'Bearer ${this.apiKey}',
          'Content-Type': 'application/json',
        },
      ),
    );
  }

  @override
  Future<String> generateText(String prompt) async {
    try {
      final response = await _dio.post(
        '/chat/completions',
        data: {
          'model': 'gpt-3.5-turbo',
          'messages': [
            {'role': 'user', 'content': prompt},
          ],
          'temperature': 0.7,
          'max_tokens': 2000,
        },
      );

      return response.data['choices'][0]['message']['content'] ?? '';
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<String> analyzeImage(String imagePath) async {
    try {
      final response = await _dio.post(
        '/chat/completions',
        data: {
          'model': 'gpt-4-vision-preview',
          'messages': [
            {
              'role': 'user',
              'content': [
                {'type': 'text', 'text': 'Analyze this image'},
                {
                  'type': 'image_url',
                  'image_url': {'url': imagePath},
                },
              ],
            },
          ],
        },
      );

      return response.data['choices'][0]['message']['content'] ?? '';
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<String> generateCode(String description) async {
    return generateText(
      'Generate code for: $description. Provide only the code without explanations.',
    );
  }

  String _handleDioError(DioException e) {
    if (e.response?.statusCode == 401) {
      return 'Invalid API key';
    } else if (e.type == DioExceptionType.connectionTimeout) {
      return 'Request timeout';
    }
    return 'Error: ${e.message}';
  }
}

class GoogleGeminiService extends AIServiceBase {
  final String apiKey;
  late final Dio _dio;

  GoogleGeminiService({String? apiKey})
    : apiKey = apiKey ?? AppConstants.googleGeminiApiKey {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppConstants.googleGeminiUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
      ),
    );
  }

  @override
  Future<String> generateText(String prompt) async {
    try {
      final response = await _dio.post(
        '/gemini-pro:generateContent',
        queryParameters: {'key': apiKey},
        data: {
          'contents': [
            {
              'parts': [
                {'text': prompt},
              ],
            },
          ],
        },
      );

      return response.data['candidates'][0]['content']['parts'][0]['text'] ??
          '';
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<String> analyzeImage(String imagePath) async {
    // Gemini image analysis implementation
    return generateText('Analyze this image: $imagePath');
  }

  @override
  Future<String> generateCode(String description) async {
    return generateText(
      'Generate code for: $description. Provide only the code without explanations.',
    );
  }

  String _handleDioError(DioException e) {
    return 'Error: ${e.message}';
  }
}

class HuggingFaceService extends AIServiceBase {
  final String apiKey;
  late final Dio _dio;

  HuggingFaceService({String? apiKey})
    : apiKey = apiKey ?? AppConstants.huggingFaceApiKey {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppConstants.huggingFaceUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {'Authorization': 'Bearer ${this.apiKey}'},
      ),
    );
  }

  @override
  Future<String> generateText(String prompt) async {
    try {
      final response = await _dio.post(
        '/models/mistralai/Mistral-7B-Instruct-v0.1',
        data: {
          'inputs': prompt,
          'parameters': {'max_length': 512},
        },
      );

      if (response.data is List && response.data.isNotEmpty) {
        return response.data[0]['generated_text'] ?? '';
      }
      return '';
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<String> analyzeImage(String imagePath) async {
    return generateText('Analyze this image: $imagePath');
  }

  @override
  Future<String> generateCode(String description) async {
    return generateText(
      'Generate code for: $description. Provide only the code.',
    );
  }

  String _handleDioError(DioException e) {
    return 'Error: ${e.message}';
  }
}

class AnthropicService extends AIServiceBase {
  final String apiKey;
  late final Dio _dio;

  AnthropicService({String? apiKey})
    : apiKey = apiKey ?? AppConstants.anthropicApiKey {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppConstants.anthropicBaseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'x-api-key': this.apiKey,
          'anthropic-version': '2023-06-01',
          'Content-Type': 'application/json',
        },
      ),
    );
  }

  @override
  Future<String> generateText(String prompt) async {
    try {
      final response = await _dio.post(
        '/messages',
        data: {
          'model': 'claude-3-sonnet-20240229',
          'max_tokens': 2000,
          'messages': [
            {'role': 'user', 'content': prompt},
          ],
        },
      );

      return response.data['content'][0]['text'] ?? '';
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<String> analyzeImage(String imagePath) async {
    return generateText('Analyze this image: $imagePath');
  }

  @override
  Future<String> generateCode(String description) async {
    return generateText(
      'Generate code for: $description. Provide clean, well-structured code.',
    );
  }

  String _handleDioError(DioException e) {
    return 'Error: ${e.message}';
  }
}
