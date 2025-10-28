import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/quiz_controller.dart';
import '../controllers/user_controller.dart';
import '../models/quiz_model.dart';
import '../widgets/quiz_card.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int? _selectedAnswer;
  bool _showResult = false;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => QuizController(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Quiz de Funções'),
          backgroundColor: Colors.blue[700],
          foregroundColor: Colors.white,
        ),
        body: Consumer3<QuizController, UserController, QuizController>(
          builder: (context, quizController, userController, _, child) {
            if (quizController.isLoading) {
              return _buildLoadingScreen();
            }

            if (quizController.questions.isEmpty) {
              return _buildStartScreen(quizController);
            }

            if (quizController.isQuizFinished) {
              return _buildResultsScreen(quizController, userController);
            }

            return _buildQuizScreen(quizController);
          },
        ),
      ),
    );
  }

  Widget _buildLoadingScreen() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 20),
          Text('Gerando questões personalizadas...'),
          SizedBox(height: 10),
          Text(
            'Usando IA para criar seu quiz!',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildStartScreen(QuizController quizController) {
    QuestionType selectedType = QuestionType.both;
    int questionCount = 5;

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircleAvatar(
            radius: 60,
            backgroundColor: Colors.blue,
            child: Icon(
              Icons.quiz,
              size: 50,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 30),
          const Text(
            'Quiz de Funções Matemáticas',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          const Text(
            'Teste seus conhecimentos sobre funções lineares e quadráticas',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 40),
          
          // Seletor de tipo
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Tipo de Funções:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  DropdownButton<QuestionType>(
                    value: selectedType,
                    isExpanded: true,
                    onChanged: (QuestionType? newValue) {
                      setState(() {
                        selectedType = newValue!;
                      });
                    },
                    items: const [
                      DropdownMenuItem(
                        value: QuestionType.linear,
                        child: Text('Apenas Funções Lineares (1º Grau)'),
                      ),
                      DropdownMenuItem(
                        value: QuestionType.quadratic,
                        child: Text('Apenas Funções Quadráticas (2º Grau)'),
                      ),
                      DropdownMenuItem(
                        value: QuestionType.both,
                        child: Text('Ambos os Tipos'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          
          // Seletor de quantidade
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Número de Questões:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  DropdownButton<int>(
                    value: questionCount,
                    isExpanded: true,
                    onChanged: (int? newValue) {
                      setState(() {
                        questionCount = newValue!;
                      });
                    },
                    items: const [
                      DropdownMenuItem(value: 5, child: Text('5 questões')),
                      DropdownMenuItem(value: 10, child: Text('10 questões')),
                      DropdownMenuItem(value: 15, child: Text('15 questões')),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 30),
          
          // Botão iniciar
          ElevatedButton(
            onPressed: () {
              quizController.loadQuestions(selectedType, questionCount);
              _resetQuizState();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
            ),
            child: const Text(
              'Iniciar Quiz',
              style: TextStyle(fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuizScreen(QuizController quizController) {
    final question = quizController.currentQuestion!;
    
    return Column(
      children: [
        // Barra de progresso
        LinearProgressIndicator(
          value: (quizController.currentQuestionIndex + 1) / 
                 quizController.totalQuestions,
          backgroundColor: Colors.grey[300],
          color: Colors.blue,
        ),
        
        // Pontuação atual
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.blue[50],
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildScoreItem('Pontuação', '${quizController.score}'),
              _buildScoreItem('Sequência', '${quizController.streak}'),
              _buildScoreItem(
                'Questão', 
                '${quizController.currentQuestionIndex + 1}/${quizController.totalQuestions}'
              ),
            ],
          ),
        ),
        
        // Questão
        Expanded(
          child: SingleChildScrollView(
            child: QuizCard(
              question: question,
              currentIndex: quizController.currentQuestionIndex,
              totalQuestions: quizController.totalQuestions,
              onAnswerSelected: (index) {
                setState(() {
                  _selectedAnswer = index;
                  _showResult = true;
                });
                quizController.checkAnswer(index);
              },
              selectedAnswer: _selectedAnswer,
              showResult: _showResult,
            ),
          ),
        ),
        
        // Botões de navegação
        if (_showResult) _buildNavigationButtons(quizController),
      ],
    );
  }

  Widget _buildScoreItem(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
      ],
    );
  }

  Widget _buildNavigationButtons(QuizController quizController) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          if (!quizController.isLastQuestion) ...[
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    _selectedAnswer = null;
                    _showResult = false;
                  });
                  quizController.nextQuestion();
                },
                child: const Text('Próxima Questão'),
              ),
            ),
          ] else ...[
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    _selectedAnswer = null;
                    _showResult = false;
                  });
                  quizController.nextQuestion();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Ver Resultados'),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildResultsScreen(QuizController quizController, UserController userController) {
    // Atualiza a pontuação do usuário
    userController.addPoints(quizController.score);
    
    // Verifica medalhas
    if (quizController.streak >= 10) {
      userController.addBadge('Mestre das Retas');
    }
    if (quizController.score >= 80) {
      userController.addBadge('Expert em Funções');
    }

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.emoji_events,
            size: 80,
            color: Colors.amber,
          ),
          const SizedBox(height: 20),
          const Text(
            'Quiz Concluído!',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          const SizedBox(height: 30),
          
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _buildResultItem('Pontuação Final', '${quizController.score}'),
                  _buildResultItem('Questões Corretas', '${(quizController.score / 10).toInt()}/${quizController.totalQuestions}'),
                  _buildResultItem('Maior Sequência', '${quizController.streak}'),
                  _buildResultItem('Pontos Ganhos', '+${quizController.score}'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 30),
          
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    quizController.resetQuiz();
                    _resetQuizState();
                  },
                  child: const Text('Jogar Novamente'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const QuizScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Novo Quiz'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildResultItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 16),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }

  void _resetQuizState() {
    setState(() {
      _selectedAnswer = null;
      _showResult = false;
    });
  }
}