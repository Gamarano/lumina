import 'package:flutter/material.dart';
import 'package:lumina_funcoes_em_acao/models/function_model.dart';
import 'package:provider/provider.dart';
import '../controllers/function_controller.dart';
import '../controllers/user_controller.dart';
import '../widgets/function_graph.dart';
import '../widgets/slider_controls.dart';

class LearnScreen extends StatefulWidget {
  const LearnScreen({super.key});

  @override
  State<LearnScreen> createState() => _LearnScreenState();
}

class _LearnScreenState extends State<LearnScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Aprender Funções'),
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: _showInstructions,
          ),
        ],
      ),
      body: ChangeNotifierProvider(
        create: (context) => FunctionController(),
        child: Consumer2<FunctionController, UserController>(
          builder: (context, functionController, userController, child) {
            final function = functionController.currentFunction;
            
            // Registra a função estudada
            WidgetsBinding.instance.addPostFrameCallback((_) {
              userController.addStudiedFunction(function.equation);
            });

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Gráfico interativo
                  FunctionGraph(function: function),
                  
                  const SizedBox(height: 20),
                  
                  // Controles deslizantes
                  SliderControls(
                    function: function,
                    onAChanged: functionController.updateA,
                    onBChanged: functionController.updateB,
                    onCChanged: functionController.updateC,
                    onTypeChanged: functionController.changeFunctionType,
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Botões de ação
                  _buildActionButtons(functionController),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildActionButtons(FunctionController controller) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: controller.resetFunction,
            icon: const Icon(Icons.refresh),
            label: const Text('Resetar'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: _showStepByStep,
            icon: const Icon(Icons.explore),
            label: const Text('Explorar'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
      ],
    );
  }

  void _showInstructions() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Como usar esta tela'),
        content: const SingleChildScrollView(
          child: Text(
            '• Use os controles deslizantes para alterar os coeficientes\n'
            '• Digite valores específicos nos campos de texto\n'
            '• Observe como o gráfico muda em tempo real\n'
            '• Mude entre funções lineares e quadráticas\n'
            '• Use "Explorar" para ver explicações detalhadas\n'
            '• "Resetar" volta para os valores padrão',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Entendi'),
          ),
        ],
      ),
    );
  }

  void _showStepByStep() {
    final function = Provider.of<FunctionController>(context, listen: false).currentFunction;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Passo a Passo'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Função: ${function.equation}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ..._buildStepByStepExplanation(function),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildStepByStepExplanation(FunctionModel function) {
    if (function.type == FunctionType.linear) {
      return [
        _buildStep('1. Identifique os coeficientes:', 'a = ${function.a}, b = ${function.b}'),
        _buildStep('2. O coeficiente "a" define a inclinação:', 'Quando a > 0, a reta sobe; quando a < 0, a reta desce'),
        _buildStep('3. O coeficiente "b" é o intercepto y:', 'A reta corta o eixo y no ponto (0, ${function.b})'),
        _buildStep('4. Para encontrar pontos:', 'Substitua valores de x na equação y = ${function.a}x + ${function.b}'),
      ];
    } else {
      final vertexX = -function.b / (2 * function.a);
      final vertexY = function.calculate(vertexX);
      
      return [
        _buildStep('1. Identifique os coeficientes:', 'a = ${function.a}, b = ${function.b}, c = ${function.c}'),
        _buildStep('2. O coeficiente "a" define a concavidade:', function.a > 0 ? 'Concavidade para cima (U)' : 'Concavidade para baixo (∩)'),
        _buildStep('3. Encontre o vértice:', 'x = -b/(2a) = ${vertexX.toStringAsFixed(2)}, y = ${vertexY.toStringAsFixed(2)}'),
        _buildStep('4. O vértice é o ponto:', function.a > 0 ? 'Mínimo da função' : 'Máximo da função'),
        _buildStep('5. Para encontrar outros pontos:', 'Substitua valores de x em y = ${function.a}x² + ${function.b}x + ${function.c}'),
      ];
    }
  }

  Widget _buildStep(String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(description),
        ],
      ),
    );
  }
}