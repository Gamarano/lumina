import 'package:flutter/material.dart';
import '../models/function_model.dart';

/// Controlador para gerenciar o estado das funções matemáticas
class FunctionController with ChangeNotifier {
  FunctionModel _currentFunction = FunctionModel(
    a: 1.0,
    b: 0.0,
    c: 0.0,
    type: FunctionType.linear,
  );

  FunctionModel get currentFunction => _currentFunction;

  /// Atualiza o coeficiente A
  void updateA(double newValue) {
    _currentFunction = FunctionModel(
      a: newValue,
      b: _currentFunction.b,
      c: _currentFunction.c,
      type: _currentFunction.type,
    );
    notifyListeners();
  }

  /// Atualiza o coeficiente B
  void updateB(double newValue) {
    _currentFunction = FunctionModel(
      a: _currentFunction.a,
      b: newValue,
      c: _currentFunction.c,
      type: _currentFunction.type,
    );
    notifyListeners();
  }

  /// Atualiza o coeficiente C
  void updateC(double newValue) {
    _currentFunction = FunctionModel(
      a: _currentFunction.a,
      b: _currentFunction.b,
      c: newValue,
      type: _currentFunction.type,
    );
    notifyListeners();
  }

  /// Altera o tipo de função
  void changeFunctionType(FunctionType newType) {
    _currentFunction = FunctionModel(
      a: _currentFunction.a,
      b: _currentFunction.b,
      c: _currentFunction.c,
      type: newType,
    );
    notifyListeners();
  }

  /// Reseta a função para valores padrão
  void resetFunction() {
    _currentFunction = FunctionModel(
      a: 1.0,
      b: 0.0,
      c: 0.0,
      type: _currentFunction.type,
    );
    notifyListeners();
  }
}