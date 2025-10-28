import 'package:flutter/material.dart';
import '../models/quiz_model.dart';

/// Widget para exibir uma questão do quiz
class QuizCard extends StatelessWidget {
  final QuizQuestion question;
  final int currentIndex;
  final int totalQuestions;
  final Function(int) onAnswerSelected;
  final int? selectedAnswer;
  final bool showResult;

  const QuizCard({
    super.key,
    required this.question,
    required this.currentIndex,
    required this.totalQuestions,
    required this.onAnswerSelected,
    this.selectedAnswer,
    this.showResult = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cabeçalho com progresso
            _buildHeader(),
            const SizedBox(height: 20),
            
            // Questão
            Text(
              question.question,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            
            // Opções de resposta
            ..._buildOptions(),
            
            // Explicação (se mostrar resultado)
            if (showResult && selectedAnswer != null) ...[
              const SizedBox(height: 20),
              _buildExplanation(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Questão ${currentIndex + 1}/$totalQuestions',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
        Chip(
          label: Text(
            question.type == QuestionType.linear ? '1º Grau' : '2º Grau',
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: question.type == QuestionType.linear 
              ? Colors.green 
              : Colors.orange,
        ),
      ],
    );
  }

  List<Widget> _buildOptions() {
    return question.options.asMap().entries.map((entry) {
      final index = entry.key;
      final option = entry.value;
      
      Color? backgroundColor;
      Color? textColor;
      IconData? icon;
      
      if (showResult && selectedAnswer != null) {
        if (index == question.correctAnswerIndex) {
          backgroundColor = Colors.green.withOpacity(0.2);
          textColor = Colors.green;
          icon = Icons.check_circle;
        } else if (index == selectedAnswer && index != question.correctAnswerIndex) {
          backgroundColor = Colors.red.withOpacity(0.2);
          textColor = Colors.red;
          icon = Icons.cancel;
        }
      }
      
      return Container(
        margin: const EdgeInsets.only(bottom: 12),
        child: ListTile(
          leading: Text(
            '${String.fromCharCode(65 + index)}.',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: textColor ?? Colors.grey[700],
            ),
          ),
          title: Text(
            option,
            style: TextStyle(
              color: textColor ?? Colors.black,
            ),
          ),
          trailing: icon != null ? Icon(icon, color: textColor) : null,
          tileColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(
              color: textColor ?? Colors.grey[300]!,
            ),
          ),
          onTap: !showResult ? () => onAnswerSelected(index) : null,
        ),
      );
    }).toList();
  }

  Widget _buildExplanation() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '📚 Explicação:',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          const SizedBox(height: 8),
          Text(question.explanation),
        ],
      ),
    );
  }
}