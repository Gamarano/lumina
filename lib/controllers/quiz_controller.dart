import 'package:flutter/material.dart';
import '../models/quiz_model.dart';
import '../services/gemini_service.dart';

/// Controlador para gerenciar o estado do quiz
class QuizController with ChangeNotifier {
  final GeminiService _geminiService = GeminiService();
  
  List<QuizQuestion> _questions = [];
  int _currentQuestionIndex = 0;
  int _score = 0;
  int _streak = 0;
  bool _isLoading = false;
  QuestionType _selectedType = QuestionType.both;
  
  List<QuizQuestion> get questions => _questions;
  int get currentQuestionIndex => _currentQuestionIndex;
  int get score => _score;
  int get streak => _streak;
  bool get isLoading => _isLoading;
  QuestionType get selectedType => _selectedType;
  int get totalQuestions => _questions.length;
  
  QuizQuestion? get currentQuestion {
    if (_currentQuestionIndex < _questions.length) {
      return _questions[_currentQuestionIndex];
    }
    return null;
  }

  /// Carrega questões do Gemini AI
  Future<void> loadQuestions(QuestionType type, int numberOfQuestions) async {
    _isLoading = true;
    notifyListeners();
    
    try {
      _questions = await _geminiService.generateQuestions(
        type: type,
        count: numberOfQuestions,
      );
      _currentQuestionIndex = 0;
      _score = 0;
      _streak = 0;
      _selectedType = type;
      notifyListeners();
    } catch (e) {
      // Fallback para questões locais se a API falhar
      _loadLocalQuestions(type);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Fallback com questões locais
  void _loadLocalQuestions(QuestionType type) {
    _questions = [
      QuizQuestion(
        id: '1',
        question: 'Qual é a função linear que passa pelos pontos (0,2) e (1,4)?',
        options: ['y = 2x + 2', 'y = 2x + 1', 'y = 4x + 2', 'y = x + 2'],
        correctAnswerIndex: 0,
        explanation: 'A inclinação é (4-2)/(1-0) = 2, e o intercepto y é 2.',
        type: QuestionType.linear,
      ),
      QuizQuestion(
        id: '2',
        question: 'Qual é o vértice da função y = x² - 4x + 3?',
        options: ['(2, -1)', '(1, 0)', '(-2, 15)', '(4, 3)'],
        correctAnswerIndex: 0,
        explanation: 'O vértice é em x = -b/2a = 4/2 = 2, y = 2² - 4*2 + 3 = -1.',
        type: QuestionType.quadratic,
      ),
    ];
    notifyListeners();
  }

  /// Verifica a resposta do usuário
  void checkAnswer(int selectedIndex) {
    if (currentQuestion == null) return;
    
    final isCorrect = currentQuestion!.isCorrect(selectedIndex);
    
    if (isCorrect) {
      _score += 10;
      _streak++;
      
      // Verifica se conquistou alguma medalha por streak
      if (_streak == 5) {
        // Notificar sobre medalha (implementar depois)
      } else if (_streak == 10) {
        // Notificar sobre medalha mestre
      }
    } else {
      _score = _score > 5 ? _score - 5 : 0;
      _streak = 0;
    }
    
    notifyListeners();
  }

  /// Avança para a próxima questão
  void nextQuestion() {
    if (_currentQuestionIndex < _questions.length - 1) {
      _currentQuestionIndex++;
      notifyListeners();
    }
  }

  /// Reinicia o quiz
  void resetQuiz() {
    _currentQuestionIndex = 0;
    _score = 0;
    _streak = 0;
    notifyListeners();
  }

  /// Verifica se é a última questão
  bool get isLastQuestion {
    return _currentQuestionIndex == _questions.length - 1;
  }

  /// Verifica se o quiz terminou
  bool get isQuizFinished {
    return _currentQuestionIndex >= _questions.length;
  }
}