/// Cores do projeto
import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF2196F3);
  static const Color primaryDark = Color(0xFF1976D2);
  static const Color primaryLight = Color(0xFFBBDEFB);
  static const Color accent = Color(0xFF00E5FF);
  static const Color background = Color(0xFFFAFAFA);
}

/// Chaves para SharedPreferences
class StorageKeys {
  static const String userData = 'user_data';
  static const String userPoints = 'user_points';
  static const String userBadges = 'user_badges';
  static const String studiedFunctions = 'studied_functions';
}

/// Configurações do Gemini AI
class GeminiConfig {
  static const String apiKey = 'SUA_CHAVE_API_AQUI'; // Você vai conseguir isso depois
  static const String model = 'gemini-pro';
}