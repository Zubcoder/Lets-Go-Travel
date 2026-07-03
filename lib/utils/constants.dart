import 'package:flutter/material.dart';

class AppColors {
  static const Color background = Color(0xFF0A0E21);
  static const Color surface = Color(0xFF1A1F38);
  static const Color surfaceLight = Color(0xFF252B48);
  static const Color primary = Color(0xFFFF8C42);
  static const Color primaryLight = Color(0xFFFFAB70);
  static const Color accent = Color(0xFF00CEC9);
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFF8E95B4);
  static const Color warning = Color(0xFFFFD600);
  static const Color error = Color(0xFFFF5252);
  static const Color success = Color(0xFF4CAF50);
  static const Color cardBackground = Color(0xFF161B33);
  static const Color divider = Color(0xFF2A3052);
  static const Color shimmer = Color(0xFF2A3052);
}

class AppConstants {
  static const String appName = "Let's Go Travel";
  static const String appNameRu = "Let's Go Travel";
  static const String appTagline = 'AI-помощник для путешествий';
  static const String appVersion = '1.0.0';
  static const String supportEmail = 'zubcoder.app@yandex.ru';

  static const String onboardingDonePrefKey = 'onboarding_done';
  static const String languagePrefKey = 'language';
  static const String themePrefKey = 'theme_mode';

  static const int freeSearchesPerDay = 10;
  static const String searchCountPrefKey = 'search_count';
  static const String searchDatePrefKey = 'search_date';

  static const String baseUrl = 'https://lets-go-travel-api.fly.dev';

  // Affiliate partner URLs (Travelpayouts marker will be appended)
  static const String aviasalesUrl = 'https://www.aviasales.ru';
  static const String hotellookUrl = 'https://www.hotellook.ru';
  static const String tripsterUrl = 'https://experience.tripster.ru';
  static const String sputnik8Url = 'https://www.sputnik8.com';
  static const String discoverCarsUrl = 'https://www.discovercars.com';
  static const String chereahapaUrl = 'https://cherehapa.ru';
  static const String yesimUrl = 'https://www.yesim.app';
  static const String kiwitaxiUrl = 'https://kiwitaxi.com';
  static const String telegramBotUrl = 'https://t.me/LetsGoTravelAIBot';
}
