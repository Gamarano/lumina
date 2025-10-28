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
  QuestionType _selectedType = QuestionType.both;
  int _questionCount = 5;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz Infinito - Funções'),
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.info),
            onPressed: _showQuizInfo,
          ),
        ],
      ),
      body: Consumer2<QuizController, UserController>(
        builder: (context, quizController, userController, child) {
          return _buildBody(quizController, userController);
        },
      ),
    );
  }

  Widget _buildBody(QuizController quizController, UserController userController) {
    // Tela de carregamento inicial
    if (quizController.isLoading && quizController.questions.isEmpty) {
      return _buildLoadingScreen();
    }

    // Tela inicial (sem questões)
    if (quizController.questions.isEmpty) {
      return _buildStartScreen(quizController, userController);
    }

    // Tela do quiz em andamento (SEMPRE - quiz infinito)
    return _buildInfiniteQuizScreen(quizController, userController);
  }

  Widget _buildLoadingScreen() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 20),
          Text('Conectando com a IA...'),
          SizedBox(height: 10),
          Text(
            'Gerando questões inteligentes!',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildStartScreen(QuizController quizController, UserController userController) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircleAvatar(
            radius: 60,
            backgroundColor: Colors.blue,
            child: Icon(
              Icons.auto_awesome,
              size: 50,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 30),
          const Text(
            'Quiz Infinito com IA',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          const Text(
            'Questões ilimitadas geradas por inteligência artificial',
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
                    '🎯 Foco do Estudo:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  DropdownButton<QuestionType>(
                    value: _selectedType,
                    isExpanded: true,
                    onChanged: (QuestionType? newValue) {
                      setState(() {
                        _selectedType = newValue!;
                      });
                    },
                    items: const [
                      DropdownMenuItem(
                        value: QuestionType.linear,
                        child: Text('📈 Funções Lineares (1º Grau)'),
                      ),
                      DropdownMenuItem(
                        value: QuestionType.quadratic,
                        child: Text('📊 Funções Quadráticas (2º Grau)'),
                      ),
                      DropdownMenuItem(
                        value: QuestionType.both,
                        child: Text('🎲 Ambos os Tipos'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          
          // Seletor de quantidade inicial
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '🚀 Questões Iniciais:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  DropdownButton<int>(
                    value: _questionCount,
                    isExpanded: true,
                    onChanged: (int? newValue) {
                      setState(() {
                        _questionCount = newValue!;
                      });
                    },
                    items: const [
                      DropdownMenuItem(value: 5, child: Text('5 questões para começar')),
                      DropdownMenuItem(value: 10, child: Text('10 questões para começar')),
                      DropdownMenuItem(value: 15, child: Text('15 questões para começar')),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 30),
          
          // Estatísticas rápidas
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem('Pontuação', '${userController.user.points}'),
                  _buildStatItem('Medalhas', '${userController.user.badges.length}'),
                  _buildStatItem('Funções', '${userController.user.studiedFunctions.length}'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 30),
          
          // Botão iniciar
          ElevatedButton.icon(
            onPressed: () {
              quizController.loadQuestions(_selectedType, _questionCount);
              _resetQuizState();
            },
            icon: const Icon(Icons.play_arrow),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
            ),
            label: const Text(
              'Iniciar Quiz Infinito',
              style: TextStyle(fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfiniteQuizScreen(QuizController quizController, UserController userController) {
    final question = quizController.currentQuestion!;
    
    return Column(
      children: [
        // Barra de progresso e carregamento
        _buildQuizHeader(quizController),
        
        // Questão
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                QuizCard(
                  question: question,
                  currentIndex: quizController.currentQuestionIndex,
                  totalQuestions: quizController.questions.length,
                  onAnswerSelected: (index) {
                    setState(() {
                      _selectedAnswer = index;
                      _showResult = true;
                    });
                    
                    // Atualiza pontuação e salva
                    quizController.checkAnswer(index, (pointsEarned, streak, totalScore) {
                      userController.addPoints(pointsEarned, streak);
                      
                      // Registra função estudada do quiz
                      userController.addFunctionFromQuiz(
                        question.question, 
                        question.options[question.correctAnswerIndex]
                      );
                    });
                  },
                  selectedAnswer: _selectedAnswer,
                  showResult: _showResult,
                ),
                
                // Indicador de carregamento de mais questões
                if (quizController.isLoading && quizController.questions.isNotEmpty)
                  _buildLoadingMoreQuestions(),
              ],
            ),
          ),
        ),
        
        // Botões de navegação
        if (_showResult) _buildNavigationButtons(quizController, userController),
      ],
    );
  }

  Widget _buildQuizHeader(QuizController quizController) {
    return Column(
      children: [
        // Barra de progresso da sessão
        LinearProgressIndicator(
          value: quizController.questions.isEmpty ? 0 : 
                 (quizController.currentQuestionIndex + 1) / quizController.questions.length,
          backgroundColor: Colors.grey[300],
          color: Colors.blue,
        ),
        
        // Estatísticas em tempo real
        Container(
          padding: const EdgeInsets.all(12),
          color: Colors.blue[50],
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem('Pontos', '${quizController.sessionScore}'),
              _buildStatItem('Sequência', '${quizController.streak}'),
              _buildStatItem('Acertos', '${quizController.totalCorrect}/${quizController.totalAnswered}'),
              _buildStatItem('Questão', '${quizController.currentQuestionIndex + 1}'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingMoreQuestions() {
    return const Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          SizedBox(height: 20),
          CircularProgressIndicator(),
          SizedBox(height: 10),
          Text(
            'Carregando mais questões...',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildNavigationButtons(QuizController quizController, UserController userController) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Mensagem de bônus por sequência
          if (quizController.streak >= 10 && quizController.streak % 10 == 0)
            Container(
              padding: const EdgeInsets.all(8),
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.celebration, color: Colors.green[700], size: 16),
                  const SizedBox(width: 8),
                  Text(
                    'Bônus: +50 pontos por ${quizController.streak} acertos seguidos!',
                    style: TextStyle(
                      color: Colors.green[700],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          
          Row(
            children: [
              // Botão pular (apenas se não for a primeira questão)
              if (quizController.currentQuestionIndex > 0)
                Expanded(
                  flex: 1,
                  child: OutlinedButton(
                    onPressed: () {
                      quizController.skipQuestion();
                      _resetQuizState();
                    },
                    child: const Text('Pular'),
                  ),
                ),
              if (quizController.currentQuestionIndex > 0) const SizedBox(width: 12),
              
              // Botão próxima questão
              Expanded(
                flex: quizController.currentQuestionIndex > 0 ? 2 : 1,
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
            ],
          ),
          
          // Botão para novo quiz
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: () {
              _showNewQuizDialog(quizController);
            },
            child: const Text('Iniciar Novo Quiz'),
          ),
        ],
      ),
    );
  }

  void _showNewQuizDialog(QuizController quizController) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Novo Quiz'),
        content: const Text('Deseja iniciar um novo quiz? O progresso atual será mantido.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              quizController.loadNewQuestions(_selectedType, _questionCount);
              _resetQuizState();
            },
            child: const Text('Novo Quiz'),
          ),
        ],
      ),
    );
  }

  void _showQuizInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Como funciona o Quiz Infinito?'),
        content: const SingleChildScrollView(
          child: Text(
            '🎯 **Sistema de Pontuação:**\n'
            '• +10 pontos por acerto\n'
            '• -5 pontos por erro\n'
            '• +50 pontos bônus a cada 10 acertos consecutivos\n'
            '• Medalha a cada 100 pontos totais\n\n'
            
            '🤖 **IA Generativa:**\n'
            '• Questões geradas automaticamente\n'
            '• Conteúdo sempre novo e variado\n'
            '• Foco em teoria e interpretação\n'
            '• Fallback para questões locais se necessário\n\n'
            
            '📈 **Progresso Infinito:**\n'
            '• Continue praticando sem limites\n'
            '• Novas questões carregadas automaticamente\n'
            '• Seu progresso é salvo continuamente',
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

  void _resetQuizState() {
    setState(() {
      _selectedAnswer = null;
      _showResult = false;
    });
  }
}