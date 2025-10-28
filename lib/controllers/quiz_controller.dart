import 'package:flutter/material.dart';
import '../models/quiz_model.dart';
import '../services/gemini_service.dart';

/// Controlador para gerenciar o estado do quiz com IA infinita
class QuizController with ChangeNotifier {
  final GeminiService _geminiService = GeminiService();
  
  List<QuizQuestion> _questions = [];
  int _currentQuestionIndex = 0;
  int _sessionScore = 0; // Pontuação apenas desta sessão
  int _streak = 0;
  int _totalCorrect = 0;
  int _totalAnswered = 0;
  bool _isLoading = false;
  QuestionType _selectedType = QuestionType.both;
  bool _needsMoreQuestions = false;
  
  List<QuizQuestion> get questions => _questions;
  int get currentQuestionIndex => _currentQuestionIndex;
  int get sessionScore => _sessionScore;
  int get streak => _streak;
  int get totalCorrect => _totalCorrect;
  int get totalAnswered => _totalAnswered;
  bool get isLoading => _isLoading;
  QuestionType get selectedType => _selectedType;
  
  // Propriedades corrigidas
  bool get isQuizFinished => false; // Quiz nunca termina - é infinito!
  bool get isLastQuestion => _currentQuestionIndex == _questions.length - 1;
  bool get needsMoreQuestions => _needsMoreQuestions;
  
  QuizQuestion? get currentQuestion {
    if (_currentQuestionIndex < _questions.length) {
      return _questions[_currentQuestionIndex];
    }
    return null;
  }

  /// Carrega questões iniciais do Gemini AI
  Future<void> loadQuestions(QuestionType type, int numberOfQuestions) async {
    _isLoading = true;
    _needsMoreQuestions = false;
    notifyListeners();
    
    try {
      print('🚀 CARREGANDO QUESTÕES DA IA: $numberOfQuestions do tipo $type');
      _questions = await _geminiService.generateQuestions(
        type: type,
        count: numberOfQuestions,
      );
      
      _currentQuestionIndex = 0;
      _sessionScore = 0;
      _streak = 0;
      _totalCorrect = 0;
      _totalAnswered = 0;
      _selectedType = type;
      
      print('✅ QUESTÕES CARREGADAS: ${_questions.length}');
      
      if (_questions.isEmpty) {
        throw Exception('Nenhuma questão foi gerada');
      }
      
      notifyListeners();
      
    } catch (e) {
      print('❌ ERRO IA: $e');
      print('🔄 USANDO QUESTÕES LOCAIS...');
      _loadLocalQuestions(type);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Carrega MAIS questões mantendo o estado atual
  Future<void> loadMoreQuestions() async {
    if (_isLoading) return;
    
    _isLoading = true;
    _needsMoreQuestions = false;
    notifyListeners();
    
    try {
      print('🔄 CARREGANDO MAIS QUESTÕES...');
      final newQuestions = await _geminiService.generateQuestions(
        type: _selectedType,
        count: 5, // Sempre carrega 5 novas questões
      );
      
      _questions.addAll(newQuestions);
      print('✅ MAIS QUESTÕES ADICIONADAS: ${newQuestions.length} (Total: ${_questions.length})');
      
      notifyListeners();
      
    } catch (e) {
      print('❌ ERRO AO CARREGAR MAIS QUESTÕES: $e');
      // Não faz fallback aqui - deixa o usuário continuar com as questões atuais
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Fallback com questões locais
  void _loadLocalQuestions(QuestionType type) {
    _questions = [
      QuizQuestion(
        id: 'local_1',
        question: 'Qual é a característica principal do gráfico de uma função linear?',
        options: [
          'É sempre uma reta',
          'É sempre uma parábola', 
          'Pode ter formato de onda',
          'Sempre corta o eixo x em dois pontos'
        ],
        correctAnswerIndex: 0,
        explanation: 'Funções lineares têm a forma y = ax + b e seu gráfico é sempre uma linha reta.',
        type: QuestionType.linear,
      ),
      QuizQuestion(
        id: 'local_2',
        question: 'O que o coeficiente "a" representa em uma função quadrática?',
        options: [
          'Controla a concavidade da parábola',
          'Define onde corta o eixo y',
          'Determina a inclinação da reta',
          'Não tem influência no gráfico'
        ],
        correctAnswerIndex: 0,
        explanation: 'Em y = ax² + bx + c, o coeficiente "a" define se a parábola abre para cima (a > 0) ou para baixo (a < 0).',
        type: QuestionType.quadratic,
      ),
      QuizQuestion(
        id: 'local_3',
        question: 'Em uma função linear y = 2x + 3, qual é o intercepto no eixo y?',
        options: ['3', '2', '0', '-3'],
        correctAnswerIndex: 0,
        explanation: 'O coeficiente b (3) indica onde a reta corta o eixo y, ou seja, no ponto (0, 3).',
        type: QuestionType.linear,
      ),
      QuizQuestion(
        id: 'local_4',
        question: 'Qual afirmação é verdadeira sobre funções quadráticas?',
        options: [
          'Sempre possuem um vértice',
          'São sempre simétricas ao eixo x',
          'Não cortam o eixo y',
          'São funções de primeiro grau'
        ],
        correctAnswerIndex: 0,
        explanation: 'Toda função quadrática possui um vértice que é seu ponto de máximo ou mínimo.',
        type: QuestionType.quadratic,
      ),
      QuizQuestion(
        id: 'local_5',
        question: 'Se uma função linear tem inclinação positiva, o que acontece com y quando x aumenta?',
        options: [
          'y também aumenta',
          'y diminui',
          'y permanece constante', 
          'y se torna negativo'
        ],
        correctAnswerIndex: 0,
        explanation: 'Inclinação positiva significa que a função é crescente: quando x aumenta, y também aumenta.',
        type: QuestionType.linear,
      ),
    ];
    
    // Filtra por tipo se necessário
    if (type != QuestionType.both) {
      _questions = _questions.where((q) => q.type == type).toList();
    }
    
    print('📚 QUESTÕES LOCAIS CARREGADAS: ${_questions.length}');
    notifyListeners();
  }

  /// Verifica a resposta do usuário
  void checkAnswer(int selectedIndex, Function(int, int, int) onScoreUpdate) {
    if (currentQuestion == null) return;
    
    final isCorrect = currentQuestion!.isCorrect(selectedIndex);
    int pointsEarned = 0;
    int streakBonus = 0;
    
    if (isCorrect) {
      pointsEarned = 10;
      _streak++;
      _totalCorrect++;
      
      // Bônus por sequência de 10 acertos
      if (_streak >= 10 && _streak % 10 == 0) {
        streakBonus = 50;
        pointsEarned += streakBonus;
      }
    } else {
      pointsEarned = -5;
      _streak = 0;
    }
    
    _sessionScore += pointsEarned;
    _totalAnswered++;
    
    // Verifica se precisa carregar mais questões
    if (_currentQuestionIndex >= _questions.length - 3) {
      _needsMoreQuestions = true;
    }
    
    // Chama callback para atualizar no UserController
    onScoreUpdate(pointsEarned, _streak, _sessionScore);
    
    notifyListeners();
  }

  /// Avança para a próxima questão
  void nextQuestion() {
    if (_currentQuestionIndex < _questions.length - 1) {
      _currentQuestionIndex++;
    } else {
      // Se for a última questão, recomeça do início (quiz infinito)
      _currentQuestionIndex = 0;
    }
    
    // Carrega mais questões se necessário
    if (_needsMoreQuestions && !_isLoading) {
      loadMoreQuestions();
    }
    
    notifyListeners();
  }

  /// Reinicia o quiz mantendo as questões atuais
  void resetQuiz() {
    _currentQuestionIndex = 0;
    _sessionScore = 0;
    _streak = 0;
    _totalCorrect = 0;
    _totalAnswered = 0;
    _needsMoreQuestions = false;
    notifyListeners();
  }

  /// Carrega um novo conjunto de questões
  void loadNewQuestions(QuestionType type, int numberOfQuestions) {
    _questions.clear();
    loadQuestions(type, numberOfQuestions);
  }

  /// Pula para a próxima questão sem responder
  void skipQuestion() {
    nextQuestion();
    _streak = 0; // Reseta a sequência ao pular
    notifyListeners();
  }
}