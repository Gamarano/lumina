import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/function_model.dart';

/// Widget para exibir gráficos interativos de funções matemáticas
class FunctionGraph extends StatelessWidget {
  final FunctionModel function;
  final double minX;
  final double maxX;

  const FunctionGraph({
    super.key,
    required this.function,
    this.minX = -10,
    this.maxX = 10,
  });

  @override
  Widget build(BuildContext context) {
    // Calcula os limites do eixo Y baseado na função
    final (double minY, double maxY) = _calculateYBounds();
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          // Título do gráfico
          Text(
            function.equation,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          const SizedBox(height: 16),
          
          // Gráfico com dimensões ajustáveis
          AspectRatio(
            aspectRatio: 1.5,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: true,
                  horizontalInterval: _calculateInterval(minY, maxY),
                  verticalInterval: _calculateInterval(minX, maxX),
                ),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: _calculateInterval(minX, maxX),
                      reservedSize: 30,
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: _calculateInterval(minY, maxY),
                      reservedSize: 40,
                    ),
                  ),
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border.all(color: Colors.grey, width: 1),
                ),
                minX: minX,
                maxX: maxX,
                minY: minY,
                maxY: maxY,
                lineBarsData: [
                  LineChartBarData(
                    spots: _generatePoints(minY, maxY),
                    isCurved: function.type == FunctionType.quadratic,
                    color: Colors.blue,
                    barWidth: 3,
                    belowBarData: BarAreaData(show: false),
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(
                          radius: 4,
                          color: Colors.blue,
                          strokeWidth: 2,
                          strokeColor: Colors.white,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Legenda informativa
          const SizedBox(height: 10),
          _buildGraphInfo(minY, maxY),
        ],
      ),
    );
  }

  /// Calcula os limites do eixo Y baseado nos valores da função
  (double, double) _calculateYBounds() {
    double minY = double.infinity;
    double maxY = double.negativeInfinity;
    
    // Amostra pontos ao longo do domínio para encontrar min/max
    for (double x = minX; x <= maxX; x += 0.5) {
      try {
        double y = function.calculate(x);
        if (!y.isInfinite && !y.isNaN) {
          if (y < minY) minY = y;
          if (y > maxY) maxY = y;
        }
      } catch (e) {
        // Ignora pontos com cálculo inválido
      }
    }
    
    // Valores padrão se não encontrou pontos válidos
    if (minY.isInfinite) minY = -5;
    if (maxY.isInfinite) maxY = 5;
    
    // Adiciona margem para visualização
    double margin = (maxY - minY) * 0.1;
    if (margin == 0) margin = 1;
    
    return (minY - margin, maxY + margin);
  }

  /// Calcula intervalo apropriado para a grade
  double _calculateInterval(double min, double max) {
    double range = max - min;
    if (range <= 10) return 1;
    if (range <= 20) return 2;
    if (range <= 50) return 5;
    return 10;
  }

  /// Gera pontos para o gráfico considerando os limites
  List<FlSpot> _generatePoints(double minY, double maxY) {
    List<FlSpot> spots = [];
    
    if (function.type == FunctionType.linear) {
      // Para função linear: mostra pontos estratégicos
      final List<double> xValues = [];
      
      // Garante que temos pontos nos limites e no zero
      if (minX < 0) xValues.add(minX);
      xValues.addAll([-2.0, -1.0, 0.0, 1.0, 2.0]);
      if (maxX > 0) xValues.add(maxX);
      
      for (double x in xValues) {
        if (x >= minX && x <= maxX) {
          double y = function.calculate(x);
          // Não limita o Y - deixa o gráfico se ajustar
          spots.add(FlSpot(x, y));
        }
      }
    } else {
      // Para função quadrática: mais pontos para curva suave
      final vertexX = -function.b / (2 * function.a);
      final pointsPerSide = 10;
      final double step = (maxX - minX) / (pointsPerSide * 2);
      
      for (int i = 0; i <= pointsPerSide * 2; i++) {
        double x = minX + (i * step);
        double y = function.calculate(x);
        spots.add(FlSpot(x, y));
      }
    }
    
    // Ordena os pontos por X para melhor renderização
    spots.sort((a, b) => a.x.compareTo(b.x));
    
    return spots;
  }

  /// Informações sobre o gráfico
  Widget _buildGraphInfo(double minY, double maxY) {
    String info = '';
    
    if (function.type == FunctionType.linear) {
      final slope = function.a;
      final intercept = function.b;
      info = 'Inclinação: ${slope.toStringAsFixed(2)} | ';
      info += 'Intercepto Y: ${intercept.toStringAsFixed(2)}';
    } else {
      final vertexX = -function.b / (2 * function.a);
      final vertexY = function.calculate(vertexX);
      info = 'Vértice: (${vertexX.toStringAsFixed(2)}, ${vertexY.toStringAsFixed(2)}) | ';
      info += 'Concavidade: ${function.a > 0 ? 'Para cima' : 'Para baixo'}';
    }
    
    return Text(
      info,
      style: const TextStyle(fontSize: 12, color: Colors.grey),
      textAlign: TextAlign.center,
    );
  }
}