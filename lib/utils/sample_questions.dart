import '../models/question.dart';

final sampleQuestions = [
  Question(
    id: 'q1',
    text: 'Qual é a função cujo gráfico é uma parábola com concavidade voltada para cima?',
    options: [
      'f(x) = -x² + 2x - 3',
      'f(x) = x² - 2x + 1',
      'f(x) = -2x + 3',
      'f(x) = 3x + 1'
    ],
    correctIndex: 1,
  ),
  Question(
    id: 'q2',
    text: 'A raiz da função f(x) = 2x - 6 é:',
    options: ['x = 3', 'x = -3', 'x = 6', 'x = 0'],
    correctIndex: 0,
  ),
  Question(
    id: 'q3',
    text: 'Se f(x) = x² - 9, qual é o valor de f(3)?',
    options: ['9', '0', '-9', '6'],
    correctIndex: 1,
  ),
];
