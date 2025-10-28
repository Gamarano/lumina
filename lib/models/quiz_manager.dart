import 'question.dart';
import '../utils/sample_questions.dart';

class QuizManager {
  final List<Question> _questions = sampleQuestions;
  int _currentIndex = 0;
  int _score = 0;

  Question get currentQuestion => _questions[_currentIndex];
  int get totalQuestions => _questions.length;
  int get score => _score;
  int get currentIndex => _currentIndex + 1;

  bool get isFinished => _currentIndex >= _questions.length - 1;

  void answer(int selectedIndex) {
    if (currentQuestion.correctIndex == selectedIndex) {
      _score++;
    }
  }

  bool next() {
    if (_currentIndex < _questions.length - 1) {
      _currentIndex++;
      return true;
    }
    return false;
  }

  void reset() {
    _currentIndex = 0;
    _score = 0;
  }
}
