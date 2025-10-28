import 'package:flutter/material.dart';
import '../models/function_model.dart';

/// Widget com controles deslizantes e campos de texto para ajustar funções
class SliderControls extends StatelessWidget {
  final FunctionModel function;
  final Function(double) onAChanged;
  final Function(double) onBChanged;
  final Function(double) onCChanged;
  final Function(FunctionType) onTypeChanged;

  const SliderControls({
    super.key,
    required this.function,
    required this.onAChanged,
    required this.onBChanged,
    required this.onCChanged,
    required this.onTypeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Seletor do tipo de função
          _buildTypeSelector(),
          const SizedBox(height: 20),
          
          // Controle do coeficiente A
          _buildCoefficientControl(
            label: 'Coeficiente A',
            value: function.a,
            onChanged: onAChanged,
            min: -5,
            max: 5,
          ),
          const SizedBox(height: 16),
          
          // Controle do coeficiente B
          _buildCoefficientControl(
            label: 'Coeficiente B',
            value: function.b,
            onChanged: onBChanged,
            min: -5,
            max: 5,
          ),
          
          // Controle do coeficiente C (apenas para quadrática)
          if (function.type == FunctionType.quadratic) ...[
            const SizedBox(height: 16),
            _buildCoefficientControl(
              label: 'Coeficiente C',
              value: function.c,
              onChanged: onCChanged,
              min: -5,
              max: 5,
            ),
          ],
          
          const SizedBox(height: 16),
          _buildInfoText(),
        ],
      ),
    );
  }

  Widget _buildTypeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Tipo de Função:',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _buildTypeButton(
                'Linear',
                FunctionType.linear,
                function.type == FunctionType.linear,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildTypeButton(
                'Quadrática',
                FunctionType.quadratic,
                function.type == FunctionType.quadratic,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTypeButton(String text, FunctionType type, bool isSelected) {
    return ElevatedButton(
      onPressed: () => onTypeChanged(type),
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? Colors.blue : Colors.grey[300],
        foregroundColor: isSelected ? Colors.white : Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Text(text),
    );
  }

  Widget _buildCoefficientControl({
    required String label,
    required double value,
    required Function(double) onChanged,
    required double min,
    required double max,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label: ${value.toStringAsFixed(2)}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: Slider(
                value: value,
                min: min,
                max: max,
                divisions: 100,
                onChanged: onChanged,
                label: value.toStringAsFixed(2),
              ),
            ),
            const SizedBox(width: 16),
            SizedBox(
              width: 80,
              child: TextFormField(
                initialValue: value.toStringAsFixed(2),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 8),
                ),
                onChanged: (text) {
                  final newValue = double.tryParse(text);
                  if (newValue != null && newValue >= min && newValue <= max) {
                    onChanged(newValue);
                  }
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInfoText() {
    String info = '';
    
    if (function.type == FunctionType.linear) {
      info = 'Função Linear: y = ax + b\n'
             '• "a" controla a inclinação\n'
             '• "b" controla onde corta o eixo y';
    } else {
      info = 'Função Quadrática: y = ax² + bx + c\n'
             '• "a" controla a concavidade\n'
             '• "b" e "c" afetam a posição\n'
             '• Vértice em x = -b/(2a)';
    }
    
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        info,
        style: const TextStyle(fontSize: 12, color: Colors.blue),
      ),
    );
  }
}