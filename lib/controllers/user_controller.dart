import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/storage_service.dart';

/// Controlador para gerenciar o estado do usuário
class UserController with ChangeNotifier {
  UserModel _user = UserModel(name: 'Estudante');
  final StorageService _storageService = StorageService();

  UserModel get user => _user;

  UserController() {
    _loadUserData();
  }

  /// Carrega os dados do usuário do armazenamento local
  void _loadUserData() async {
    final userData = await _storageService.getUserData();
    if (userData != null) {
      _user = userData;
      notifyListeners();
    }
  }

  /// Atualiza o nome do usuário
  void updateName(String newName) {
    _user.name = newName;
    _storageService.saveUserData(_user);
    notifyListeners();
  }

  /// Adiciona pontos ao usuário e verifica medalhas
  void addPoints(int points, [int streak = 0]) {
    final oldScore = _user.points;
    _user.addPoints(points);
    
    // Verifica medalha a cada 100 pontos
    if (_user.points ~/ 100 > oldScore ~/ 100) {
      final hundredCount = _user.points ~/ 100;
      addBadge('${hundredCount * 100} Pontos');
    }
    
    // Verifica medalha por sequência
    if (streak >= 10) {
      addBadge('Sequência de $streak');
      // Adiciona bônus por sequência
      _user.addPoints(50);
    }
    
    _storageService.saveUserData(_user);
    notifyListeners();
  }

  /// Adiciona uma medalha
  void addBadge(String badge) {
    // Verifica se a medalha já existe
    if (!_user.badges.contains(badge)) {
      _user.addBadge(badge);
      _storageService.saveUserData(_user);
      notifyListeners();
    }
  }

  /// Adiciona uma função estudada (agora do quiz também)
  void addStudiedFunction(String function) {
    // Adiciona apenas se for uma função matemática válida
    if (_isValidFunction(function)) {
      _user.addStudiedFunction(function);
      _storageService.saveUserData(_user);
      notifyListeners();
    }
  }

  /// Verifica se é uma função matemática válida
  bool _isValidFunction(String function) {
    return function.contains('y =') || 
           function.contains('x') ||
           function.contains('=');
  }

  /// Adiciona função do quiz
  void addFunctionFromQuiz(String question, String correctAnswer) {
    // Extrai a função da questão ou resposta correta
    String function = _extractFunctionFromText(question) ?? 
                     _extractFunctionFromText(correctAnswer) ?? 
                     'Função relacionada: $question';
    
    addStudiedFunction(function);
  }

  /// Tenta extrair uma função do texto
  String? _extractFunctionFromText(String text) {
    // Procura por padrões de função matemática
    final functionPattern = RegExp(r'y\s*=\s*[+-]?\d*x\s*[+-]?\s*\d*');
    final match = functionPattern.firstMatch(text);
    if (match != null) {
      return match.group(0);
    }
    return null;
  }

  /// Reseta o progresso (para testes)
  void resetProgress() {
    _user = UserModel(name: _user.name);
    _storageService.saveUserData(_user);
    notifyListeners();
  }

  /// Retorna estatísticas do usuário
  Map<String, dynamic> get stats {
    return {
      'totalPoints': _user.points,
      'totalBadges': _user.badges.length,
      'studiedFunctions': _user.studiedFunctions.length,
      'accuracy': _user.points > 0 ? ((_user.points / (_user.points + 100)) * 100).toStringAsFixed(1) : '0',
    };
  }
}