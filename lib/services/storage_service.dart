import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

/// Serviço para armazenamento local usando SharedPreferences
class StorageService {
  static const String _userNameKey = 'user_name';
  static const String _userPointsKey = 'user_points';
  static const String _userBadgesKey = 'user_badges';
  static const String _studiedFunctionsKey = 'studied_functions';

  /// Salva os dados do usuário
  Future<void> saveUserData(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    
    await prefs.setString(_userNameKey, user.name);
    await prefs.setInt(_userPointsKey, user.points);
    await prefs.setStringList(_userBadgesKey, user.badges);
    await prefs.setStringList(_studiedFunctionsKey, user.studiedFunctions);
  }

  /// Carrega os dados do usuário
  Future<UserModel?> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    
    final name = prefs.getString(_userNameKey) ?? 'Estudante';
    final points = prefs.getInt(_userPointsKey) ?? 0;
    final badges = prefs.getStringList(_userBadgesKey) ?? [];
    final studiedFunctions = prefs.getStringList(_studiedFunctionsKey) ?? [];
    
    return UserModel(
      name: name,
      points: points,
      badges: badges,
      studiedFunctions: studiedFunctions,
    );
  }

  /// Limpa todos os dados (para testes)
  Future<void> clearAllData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}