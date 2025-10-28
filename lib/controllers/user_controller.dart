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

  /// Adiciona pontos ao usuário
  void addPoints(int points) {
    _user.addPoints(points);
    _storageService.saveUserData(_user);
    notifyListeners();
  }

  /// Adiciona uma medalha
  void addBadge(String badge) {
    _user.addBadge(badge);
    _storageService.saveUserData(_user);
    notifyListeners();
  }

  /// Adiciona uma função estudada
  void addStudiedFunction(String function) {
    _user.addStudiedFunction(function);
    _storageService.saveUserData(_user);
    notifyListeners();
  }

  /// Reseta o progresso (para testes)
  void resetProgress() {
    _user = UserModel(name: _user.name);
    _storageService.saveUserData(_user);
    notifyListeners();
  }
}