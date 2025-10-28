import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math';

class LaboratorioScreen extends StatefulWidget {
  const LaboratorioScreen({super.key});

  @override
  State<LaboratorioScreen> createState() => _LaboratorioScreenState();
}

class _LaboratorioScreenState extends State<LaboratorioScreen> {
  double a = 1, b = 0, c = 0;

  List<FlSpot> getPoints() {
    final List<FlSpot> points = [];
    for (double x = -10; x <= 10; x += 0.5) {
      final y = a * pow(x, 2) + b * x + c;
      points.add(FlSpot(x, y.toDouble()));
    }
    return points;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Laboratório — f(x) = ax² + bx + c')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _paramInput('a', a, (v) => setState(() => a = v)),
                _paramInput('b', b, (v) => setState(() => b = v)),
                _paramInput('c', c, (v) => setState(() => c = v)),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: LineChart(
                LineChartData(
                  backgroundColor: Colors.white,
                  gridData: const FlGridData(show: true),
                  titlesData: FlTitlesData(show: true),
                  borderData: FlBorderData(show: true),
                  lineBarsData: [
                    LineChartBarData(
                      isCurved: true,
                      spots: getPoints(),
                      color: Colors.indigo,
                      barWidth: 3,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'f(x) = ${a.toStringAsFixed(1)}x² + ${b.toStringAsFixed(1)}x + ${c.toStringAsFixed(1)}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }

  Widget _paramInput(String label, double value, Function(double) onChanged) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(
          width: 60,
          child: TextField(
            controller: TextEditingController(text: value.toStringAsFixed(1)),
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            onSubmitted: (val) {
              final parsed = double.tryParse(val);
              if (parsed != null) onChanged(parsed);
            },
          ),
        ),
      ],
    );
  }
}
