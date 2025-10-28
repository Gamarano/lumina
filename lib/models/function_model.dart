/// Modelo para representar uma função matemática
class FunctionModel {
  final double a;
  final double b;
  final double c;
  final FunctionType type;
  
  FunctionModel({
    required this.a,
    required this.b,
    required this.c,
    required this.type,
  });
  
  /// Calcula o valor de y para um dado x
  double calculate(double x) {
    if (type == FunctionType.linear) {
      return a * x + b;
    } else {
      return a * x * x + b * x + c;
    }
  }
  
  /// Retorna a equação em formato de string
  String get equation {
    if (type == FunctionType.linear) {
      return 'y = ${a}x + ${b}';
    } else {
      return 'y = ${a}x² + ${b}x + ${c}';
    }
  }
}

/// Tipo de função
enum FunctionType {
  linear,
  quadratic,
}