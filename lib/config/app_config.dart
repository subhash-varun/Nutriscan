import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  static const String appName = 'NutriScan';
  static const String appVersion = '2.1.2';

  static const String buildNumber = '3';

  // Stripe Configuration from .env
  static String get stripePublishableKey =>
      dotenv.env['STRIPE_PUBLISHABLE_KEY'] ?? '';
  static String get stripeSecretKey => dotenv.env['STRIPE_SECRET_KEY'] ?? '';

  static const double monthlyPrice = 4.99;
  static const double yearlyPrice = 49.99;
}
