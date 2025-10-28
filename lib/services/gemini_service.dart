import 'dart:convert';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:lumina_funcoes_em_acao/models/function_model.dart';
import '../models/quiz_model.dart';

/// Serviço para integração com a API do Google Gemini AI
class GeminiService {
  static const String _apiKey = 'AIzaSyCHYTzeOBP4D_k3nus0mj0yzIBFDC_8PAk'; // Substitua pela sua chave
  late final GenerativeModel _model;

  GeminiService() {
    _model = GenerativeModel(
      model: 'gemini-pro',
      apiKey: _apiKey,
    );
  }

  /// Gera questões de quiz usando IA
  Future<List<QuizQuestion>> generateQuestions({
    required QuestionType type,
    required int count,
  }) async {
    try {
      final prompt = _buildPrompt(type, count);
      final response = await _model.generateContent([Content.text(prompt)]);
      
      final text = response.text;
      if (text == null) {
        throw Exception('Resposta vazia do Gemini');
      }
      
      return _parseQuestions(text, type);
    } catch (e) {
      print('Erro ao gerar questões: $e');
      throw Exception('Falha ao carregar questões. Usando questões locais.');
    }
  }

  /// Constrói o prompt para o Gemini
  String _buildPrompt(QuestionType type, int count) {
    String functionType = '';
    switch (type) {
      case QuestionType.linear:
        functionType = 'funções lineares (1º grau)';
        break;
      case QuestionType.quadratic:
        functionType = 'funções quadráticas (2º grau)';
        break;
      case QuestionType.both:
        functionType = 'funções lineares e quadráticas';
        break;
    }

    return '''
Você é um assistente especializado em educação matemática para ensino médio. 
Gere $count questões sobre $functionType no formato JSON específico abaixo.

FORMATO DE RESPOSTA JSON:
{
  "questions": [
    {
      "id": "string única",
      "question": "texto da pergunta",
      "options": ["opção A", "opção B", "opção C", "opção D"],
      "correctAnswerIndex": 0,
      "explanation": "explicação detalhada da resposta",
      "type": "linear|quadratic"
    }
  ]
}

REGRAS:
- As questões devem ser em PORTUGUÊS-BR
- Dificuldade: ensino médio (15-18 anos)
- 4 opções de resposta (A, B, C, D)
- correctAnswerIndex: 0-3 (índice da opção correta)
- Explicações devem ser educativas e claras
- Inclua questões teóricas e práticas
- Para funções quadráticas, inclua questões sobre vértice, concavidade, raízes
- Para funções lineares, inclua questões sobre inclinação, interceptos, gráficos

EXEMPLOS DE QUESTÕES:
1. "Qual é o vértice da função y = 2x² - 8x + 6?"
2. "Qual função linear tem inclinação 3 e corta o eixo y em -2?"
3. "Dada a função y = -x + 5, qual é o valor de y quando x = 3?"

Gere $count questões variadas e educativas.
''';
  }

  /// Analisa a resposta do Gemini e converte para objetos QuizQuestion
  List<QuizQuestion> _parseQuestions(String response, QuestionType requestedType) {
    try {
      // Tenta encontrar o JSON na resposta
      final jsonStart = response.indexOf('{');
      final jsonEnd = response.lastIndexOf('}') + 1;
      
      if (jsonStart == -1 || jsonEnd == -1) {
        throw Exception('JSON não encontrado na resposta');
      }
      
      final jsonString = response.substring(jsonStart, jsonEnd);
      final jsonData = json.decode(jsonString);
      
      final questions = jsonData['questions'] as List;
      
      return questions.map((q) {
        // Converte o tipo de string para enum
        QuestionType type;
        switch (q['type']) {
          case 'linear':
            type = QuestionType.linear;
            break;
          case 'quadratic':
            type = QuestionType.quadratic;
            break;
          default:
            type = QuestionType.linear;
        }
        
        return QuizQuestion(
          id: q['id'] ?? DateTime.now().microsecondsSinceEpoch.toString(),
          question: q['question'],
          options: List<String>.from(q['options']),
          correctAnswerIndex: q['correctAnswerIndex'],
          explanation: q['explanation'],
          type: type,
        );
      }).toList();
    } catch (e) {
      print('Erro ao analisar questões: $e');
      throw Exception('Falha ao processar questões do Gemini');
    }
  }

  /// Gera explicações passo a passo para funções
  Future<String> generateStepByStepExplanation(
    String functionEquation,
    FunctionType functionType,
  ) async {
    try {
      final prompt = '''
Explique passo a passo a função: $functionEquation

Tipo: ${functionType == FunctionType.linear ? 'Função Linear' : 'Função Quadrática'}

Forneça uma explicação educativa em português com:
1. Identificação dos coeficientes
2. Significado de cada coeficiente
3. Como o gráfico se comporta
4. Pontos importantes (interceptos, vértice se for quadrática)
5. Exemplo de cálculo para 2-3 valores de x

Seja claro e educacional, para estudantes do ensino médio.
''';

      final response = await _model.generateContent([Content.text(prompt)]);
      return response.text ?? 'Explicação não disponível.';
    } catch (e) {
      return 'Erro ao gerar explicação. Tente novamente.';
    }
  }
}