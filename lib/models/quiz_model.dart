/// Modelo para representar uma questão do quiz
class QuizQuestion {
  final String id;
  final String question;
  final List<String> options;
  final int correctAnswerIndex;
  final String explanation;
  final QuestionType type;
  final String? graphEquation; // Para questões com gráficos

  QuizQuestion({
    required this.id,
    required this.question,
    required this.options,
    required this.correctAnswerIndex,
    required this.explanation,
    required this.type,
    this.graphEquation,
  });

  // Método para verificar se a resposta está correta
  bool isCorrect(int selectedIndex) {
    return selectedIndex == correctAnswerIndex;
  }
}

/// Tipo de questão
enum QuestionType {
  linear,
  quadratic,
  both,
}

/// Resultado de uma sessão de quiz
class QuizResult {
  final int score;
  final int totalQuestions;
  final int correctAnswers;
  final DateTime date;
  final List<QuestionResult> questionResults;

  QuizResult({
    required this.score,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.date,
    required this.questionResults,
  });

  double get percentage => (correctAnswers / totalQuestions) * 100;
}

/// Resultado individual de cada questão
class QuestionResult {
  final String questionId;
  final bool isCorrect;
  final int timeSpent; // em segundos

  QuestionResult({
    required this.questionId,
    required this.isCorrect,
    required this.timeSpent,
  });
}