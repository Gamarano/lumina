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
    this.minX = -5,
    this.maxX = 5,
  });

  @override
  Widget build(BuildContext context) {
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
          
          // Gráfico
          AspectRatio(
            aspectRatio: 1.5,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: true,
                  horizontalInterval: 1,
                  verticalInterval: 1,
                ),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 1,
                      reservedSize: 30,
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 1,
                      reservedSize: 30,
                    ),
                  ),
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border.all(color: Colors.grey),
                ),
                minX: minX,
                maxX: maxX,
                minY: -5,
                maxY: 5,
                lineBarsData: [
                  LineChartBarData(
                    spots: _generatePoints(),
                    isCurved: function.type == FunctionType.quadratic,
                    color: Colors.blue,
                    barWidth: 3,
                    belowBarData: BarAreaData(show: false),
                    dotData: FlDotData(show: true),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Gera os pontos para o gráfico baseado no tipo de função
  List<FlSpot> _generatePoints() {
    List<FlSpot> spots = [];
    
    if (function.type == FunctionType.linear) {
      // Para função linear: mostra 5 pontos estratégicos
      final points = [-2.0, -1.0, 0.0, 1.0, 2.0];
      for (double x in points) {
        double y = function.calculate(x);
        // Limita o valor de y para não sair do gráfico
        if (y > 5) y = 5;
        if (y < -5) y = -5;
        spots.add(FlSpot(x, y));
      }
    } else {
      // Para função quadrática: mostra pontos ao redor do vértice
      final vertexX = -function.b / (2 * function.a);
      final points = [
        vertexX - 2,
        vertexX - 1,
        vertexX,
        vertexX + 1,
        vertexX + 2
      ];
      
      for (double x in points) {
        if (x >= minX && x <= maxX) {
          double y = function.calculate(x);
          // Limita o valor de y para não sair do gráfico
          if (y > 5) y = 5;
          if (y < -5) y = -5;
          spots.add(FlSpot(x, y));
        }
      }
    }
    
    return spots;
  }
}