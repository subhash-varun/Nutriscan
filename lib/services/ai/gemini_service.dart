import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:nutriscan/config/api_config.dart';

class GeminiService {
  static String get _apiKey => ApiConfig.geminiApiKey;
  static String get _model => ApiConfig.geminiModel;

  late final Dio _dio;

  GeminiService() {
    _dio = Dio();
    _dio.options.connectTimeout = const Duration(seconds: 30);
    _dio.options.receiveTimeout = const Duration(seconds: 30);
    _dio.options.sendTimeout = const Duration(seconds: 30);
  }

  Future<Map<String, dynamic>> analyzeFoodImage(
    File imageFile, {
    String language = 'en',
  }) async {
    final imageBytes = await imageFile.readAsBytes();
    final base64Image = base64Encode(imageBytes);

    final String prompt = '''
Analyze this food image and return ONLY a single valid JSON object without markdown syntax or extra text.
Format requirements:
{
  "name": "Food Name in ${language == 'bn' ? 'Bengali' : 'English'}",
  "calories": 350.0,
  "protein": 15.0,
  "carbs": 45.0,
  "fat": 10.0,
  "fiber": 4.0,
  "sugar": 5.0,
  "healthScore": 85,
  "description": "Short description of the meal in ${language == 'bn' ? 'Bengali' : 'English'}",
  "healthBenefits": ["Benefit 1", "Benefit 2"],
  "healthRisks": ["Risk 1 if any"]
}
''';

    final url =
        'https://generativelanguage.googleapis.com/v1beta/models/$_model:generateContent?key=$_apiKey';

    final payload = {
      'contents': [
        {
          'parts': [
            {'text': prompt},
            {
              'inline_data': {
                'mime_type': 'image/jpeg',
                'data': base64Image,
              }
            }
          ]
        }
      ]
    };

    final response = await _dio.post(
      url,
      data: payload,
      options: Options(
        headers: {
          'Content-Type': 'application/json',
        },
      ),
    );

    if (response.statusCode == 200) {
      final candidates = response.data['candidates'];
      if (candidates != null && (candidates as List).isNotEmpty) {
        final text = candidates[0]['content']['parts'][0]['text'] as String;
        final jsonStart = text.indexOf('{');
        final jsonEnd = text.lastIndexOf('}') + 1;
        if (jsonStart != -1 && jsonEnd > jsonStart) {
          final jsonString = text.substring(jsonStart, jsonEnd);
          return json.decode(jsonString) as Map<String, dynamic>;
        }
      }
    }
    throw Exception('Gemini AI analysis failed');
  }
}
