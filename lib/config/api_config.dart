import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConfig {
  static String get groqApiKey => dotenv.env['GROQ_API_KEY'] ?? '';

  static const String groqModel = 'llama-3.3-70b-versatile';
  static const String groqVisionModel = 'qwen/qwen3.6-27b';

  static String get groqBaseUrl =>
      'https://api.groq.com/openai/v1/chat/completions';
}
