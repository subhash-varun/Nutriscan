import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:nutriscan/models/food.dart';

class BarcodeService {
  final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'User-Agent': 'NutriScan - Android/iOS App - Version 1.0',
      },
    ),
  );

  /// Fetches nutritional data from OpenFoodFacts REST API for a given barcode
  Future<Food?> fetchProductByBarcode(String barcode) async {
    try {
      final url = 'https://world.openfoodfacts.org/api/v2/product/$barcode.json';
      final response = await _dio.get(url);

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data as Map<String, dynamic>;
        if (data['status'] == 1 && data['product'] != null) {
          final product = data['product'] as Map<String, dynamic>;
          final nutriments = product['nutriments'] as Map<String, dynamic>? ?? {};

          final String name = product['product_name'] ??
              product['product_name_en'] ??
              'Scanned Package Item ($barcode)';

          final String description = product['brands'] != null
              ? 'Brand: ${product['brands']}'
              : 'Scanned packaged food product';

          final double calories = (nutriments['energy-kcal_100g'] as num?)?.toDouble() ??
              (nutriments['energy-kcal'] as num?)?.toDouble() ??
              0.0;

          final double protein = (nutriments['proteins_100g'] as num?)?.toDouble() ?? 0.0;
          final double carbs = (nutriments['carbohydrates_100g'] as num?)?.toDouble() ?? 0.0;
          final double fat = (nutriments['fat_100g'] as num?)?.toDouble() ?? 0.0;
          final double fiber = (nutriments['fiber_100g'] as num?)?.toDouble() ?? 0.0;
          final double sugar = (nutriments['sugars_100g'] as num?)?.toDouble() ?? 0.0;
          final double sodium = ((nutriments['sodium_100g'] as num?)?.toDouble() ?? 0.0) * 1000;

          // Nutri-Score calculation mapping (A=95, B=80, C=60, D=40, E=20)
          int healthScore = 70;
          final String scoreGrade = (product['nutriscore_grade'] as String?)?.toLowerCase() ?? 'c';
          switch (scoreGrade) {
            case 'a':
              healthScore = 95;
              break;
            case 'b':
              healthScore = 80;
              break;
            case 'c':
              healthScore = 65;
              break;
            case 'd':
              healthScore = 45;
              break;
            case 'e':
              healthScore = 25;
              break;
          }

          final String imageUrl = product['image_url'] ?? product['image_front_url'] ?? '';

          final foodMap = {
            'id': 'barcode_$barcode',
            'food_name': name,
            'description': description,
            'calories': calories,
            'protein': protein,
            'carbs': carbs,
            'fat': fat,
            'fiber': fiber,
            'sugar': sugar,
            'sodium': sodium,
            'health_score': healthScore,
            'health_benefits': ['Rich in macronutrients', 'Scanned via OpenFoodFacts'],
            'health_warnings': sugar > 15 ? ['High sugar content per 100g'] : [],
            'serving_size': product['serving_size'] ?? '100g',
            'image_path': imageUrl,
            'analyzed_at': DateTime.now().toIso8601String(),
          };

          return Food.fromJson(foodMap);
        }
      }
      return null;
    } catch (e) {
      debugPrint('Error fetching barcode from OpenFoodFacts: $e');
      return null;
    }
  }
}
