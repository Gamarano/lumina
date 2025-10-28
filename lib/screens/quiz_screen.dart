import 'package:flutter/material.dart';
import '../models/quiz_manager.dart';
import '../widgets/quiz_option.dart';
import 'result_screen.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final QuizManager quizManager = QuizManager();
  int? selectedIndex;

  void _onSelect(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  void _onNext() {
    if (selectedIndex == null) return;

    quizManager.answer(selectedIndex!);

    if (quizManager.isFinished) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ResultScreen(score: quizManager.score, total: quizManager.totalQuestions),
        ),
      );
    } else {
      quizManager.next();
      setState(() {
        selectedIndex = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final question = quizManager.currentQuestion;

    return Scaffold(
      appBar: AppBar(
        title: Text('Questão ${quizManager.currentIndex}/${quizManager.totalQuestions}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(question.text, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            ...List.generate(
              question.options.length,
              (i) => QuizOption(
                text: question.options[i],
                isSelected: selectedIndex == i,
                onTap: () => _onSelect(i),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _onNext,
                child: Text(quizManager.isFinished ? 'Finalizar' : 'Próxima'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
