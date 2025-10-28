import 'dart:convert';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../models/function_model.dart';
import '../models/quiz_model.dart';

/// Serviço robusto para integração com Google Gemini AI
class GeminiService {
  static const String _apiKey = 'AIzaSyCHYTzeOBP4D_k3nus0mj0yzIBFDC_8PAk';
  late final GenerativeModel _model;

  GeminiService() {
    _model = GenerativeModel(
      model: 'gemini-pro',
      apiKey: _apiKey,
    );
  }

  /// Gera questões de quiz usando IA - versão SUPER robusta
  Future<List<QuizQuestion>> generateQuestions({
    required QuestionType type,
    required int count,
  }) async {
    try {
      print('🧠 SOLICITANDO $count QUESTÕES DA IA...');
      
      final prompt = _buildSmartPrompt(type, count);
      final response = await _model.generateContent([Content.text(prompt)]);
      
      final text = response.text;
      if (text == null) {
        throw Exception('Resposta vazia do Gemini');
      }
      
      print('📨 RESPOSTA DA IA RECEBIDA (${text.length} caracteres)');
      
      return _parseResponseSmart(text, type, count);
      
    } catch (e) {
      print('💥 ERRO CRÍTICO NA IA: $e');
      throw Exception('Falha na geração de questões. Use questões locais.');
    }
  }

  /// Prompt inteligente e detalhado
  String _buildSmartPrompt(QuestionType type, int count) {
    String functionType = '';
    String examples = '';
    
    switch (type) {
      case QuestionType.linear:
        functionType = 'funções lineares (1º grau)';
        examples = '''
EXEMPLOS LINEARES:
1. "Qual é o significado do coeficiente angular em uma função linear?"
2. "Como identificar se uma reta é crescente ou decrescente?"
3. "O que representa o ponto onde a reta corta o eixo y?"
4. "Dada a reta y = 3x - 2, qual seu comportamento?"
        ''';
        break;
      case QuestionType.quadratic:
        functionType = 'funções quadráticas (2º grau)';
        examples = '''
EXEMPLOS QUADRÁTICOS:
1. "O que determina a concavidade de uma parábola?"
2. "Como encontrar o vértice de uma função quadrática?"
3. "Qual a relação entre o discriminante e as raízes?"
4. "O que significa quando uma parábola não corta o eixo x?"
        ''';
        break;
      case QuestionType.both:
        functionType = 'funções lineares e quadráticas';
        examples = '''
EXEMPLOS MISTOS:
1. "Qual a diferença principal entre gráficos de funções lineares e quadráticas?"
2. "Como identificar se uma função é linear ou quadrática apenas pela equação?"
3. "Qual tipo de função sempre tem taxa de variação constante?"
4. "Que tipo de função pode ter pontos de máximo ou mínimo?"
        ''';
        break;
    }

    return '''
Você é um professor especialista em educação matemática para ensino médio.

CRIE EXATAMENTE $count QUESTÕES SOBRE: $functionType

**FORMATO OBRIGATÓRIO - APENAS JSON:** 
{
  "questions": [
    {
      "id": "1",
      "question": "Texto claro da pergunta?",
      "options": ["Opção A", "Opção B", "Opção C", "Opção D"],
      "correctAnswerIndex": 0,
      "explanation": "Explicação educativa detalhada",
      "type": "${type == QuestionType.linear ? 'linear' : type == QuestionType.quadratic ? 'quadratic' : 'linear'}"
    }
  ]
}

**REGRAS ESTRITAS:**
- APENAS 1 questão a cada 20 pode exigir cálculo numérico
- 80% questões teóricas sobre conceitos e propriedades
- 20% questões de interpretação de gráficos
- Linguagem CLARA para estudantes de 15-18 anos
- 4 opções de resposta DISTINTAS e plausíveis
- correctAnswerIndex deve ser 0, 1, 2 ou 3
- Explicações devem ensinar o conceito
- NUNCA repita questões idênticas

**DISTRIBUIÇÃO POR TIPO:**
${examples}

**INSTRUÇÃO FINAL:**
Retorne APENAS o JSON válido. Sem comentários. Sem markdown. Sem texto adicional.
''';
  }

  /// Parsing SUPER robusto da resposta
  List<QuizQuestion> _parseResponseSmart(String response, QuestionType requestedType, int expectedCount) {
    try {
      print('🔍 INICIANDO PARSING INTELIGENTE...');
      
      // Limpeza agressiva da resposta
      String cleanResponse = _cleanResponse(response);
      
      // Tentativa 1: Extrair JSON tradicional
      List<QuizQuestion>? questions = _tryExtractJson(cleanResponse, requestedType);
      if (questions != null && questions.isNotEmpty) {
        print('✅ PARSING JSON BEM-SUCEDIDO: ${questions.length} questões');
        return questions;
      }
      
      // Tentativa 2: Parsing de fallback
      questions = _fallbackParsing(cleanResponse, requestedType, expectedCount);
      if (questions != null && questions.isNotEmpty) {
        print('✅ PARSING FALLBACK BEM-SUCEDIDO: ${questions.length} questões');
        return questions;
      }
      
      throw Exception('Não foi possível extrair questões da resposta');
      
    } catch (e) {
      print('❌ FALHA NO PARSING: $e');
      print('📄 RESPOSTA QUE FALHOU: ${response.substring(0, 200)}...');
      return _generateFallbackQuestions(requestedType, expectedCount);
    }
  }

  /// Limpeza agressiva da resposta
  String _cleanResponse(String response) {
    String clean = response.trim();
    
    // Remove blocos de código markdown
    final codeBlockPattern = RegExp(r'```(?:json)?\s*(.*?)\s*```', caseSensitive: false, dotAll: true);
    final codeMatch = codeBlockPattern.firstMatch(clean);
    if (codeMatch != null) {
      clean = codeMatch.group(1) ?? clean;
    }
    
    // Remove textos comuns antes/depois do JSON
    final commonPrefixes = [
      'aqui está',
      'here is',
      'json',
      '```',
      'claro',
      'certamente'
    ];
    
    for (var prefix in commonPrefixes) {
      if (clean.toLowerCase().startsWith(prefix)) {
        clean = clean.substring(prefix.length).trim();
      }
    }
    
    return clean;
  }

  /// Tentativa principal de extrair JSON
  List<QuizQuestion>? _tryExtractJson(String response, QuestionType requestedType) {
    try {
      final jsonStart = response.indexOf('{');
      final jsonEnd = response.lastIndexOf('}') + 1;
      
      if (jsonStart == -1 || jsonEnd <= jsonStart) {
        return null;
      }
      
      final jsonString = response.substring(jsonStart, jsonEnd);
      final jsonData = json.decode(jsonString);
      
      if (jsonData['questions'] is! List) {
        return null;
      }
      
      final questions = jsonData['questions'] as List;
      final result = <QuizQuestion>[];
      
      for (var i = 0; i < questions.length; i++) {
        try {
          final q = questions[i];
          final question = _parseQuestion(q, i, requestedType);
          if (question != null) {
            result.add(question);
          }
        } catch (e) {
          print('⚠️ Questão $i ignorada: $e');
        }
      }
      
      return result.isNotEmpty ? result : null;
      
    } catch (e) {
      print('❌ Falha no JSON tradicional: $e');
      return null;
    }
  }

  /// Parsing de uma questão individual
  QuizQuestion? _parseQuestion(Map<String, dynamic> q, int index, QuestionType requestedType) {
    try {
      // Tipo da questão
      QuestionType type;
      final typeStr = (q['type'] ?? '').toString().toLowerCase();
      if (typeStr.contains('quadratic')) {
        type = QuestionType.quadratic;
      } else {
        type = QuestionType.linear; // padrão
      }
      
      // Garantir 4 opções
      List<String> options = List<String>.from(q['options'] ?? []);
      if (options.length != 4) {
        options = _generateDefaultOptions(type);
      }
      
      // Índice correto válido
      int correctIndex = (q['correctAnswerIndex'] ?? 0).toInt();
      if (correctIndex < 0 || correctIndex > 3) {
        correctIndex = 0;
      }
      
      return QuizQuestion(
        id: 'ai_${DateTime.now().millisecondsSinceEpoch}_$index',
        question: (q['question'] ?? 'Questão sobre funções matemáticas').toString(),
        options: options,
        correctAnswerIndex: correctIndex,
        explanation: (q['explanation'] ?? 'Explicação não disponível.').toString(),
        type: type,
      );
      
    } catch (e) {
      print('❌ Erro ao parsear questão individual: $e');
      return null;
    }
  }

  /// Parsing de fallback para respostas não-JSON
  List<QuizQuestion>? _fallbackParsing(String response, QuestionType requestedType, int expectedCount) {
    try {
      // Implementação simples de fallback
      // Aqui você poderia adicionar lógica mais sofisticada
      // se a IA retornar em outros formatos
      
      return _generateFallbackQuestions(requestedType, expectedCount);
      
    } catch (e) {
      return null;
    }
  }

  /// Gera questões de fallback
  List<QuizQuestion> _generateFallbackQuestions(QuestionType type, int count) {
    final allQuestions = _getLocalQuestionBank();
    
    // Filtra por tipo se necessário
    List<QuizQuestion> filtered = type == QuestionType.both 
        ? allQuestions 
        : allQuestions.where((q) => q.type == type).toList();
    
    // Limita ao count solicitado
    return filtered.take(count).toList();
  }

  /// Banco de questões locais
  List<QuizQuestion> _getLocalQuestionBank() {
    return [
      QuizQuestion(
        id: 'bank_1',
        question: 'Qual é a forma geral de uma função linear?',
        options: [
          'y = ax + b',
          'y = ax² + bx + c',
          'y = a/x + b',
          'y = √x + b'
        ],
        correctAnswerIndex: 0,
        explanation: 'A forma geral de uma função linear é y = ax + b, onde a é o coeficiente angular e b é o linear.',
        type: QuestionType.linear,
      ),
      QuizQuestion(
        id: 'bank_2',
        question: 'O que representa o vértice em uma função quadrática?',
        options: [
          'Ponto de máximo ou mínimo',
          'Onde corta o eixo x',
          'Onde corta o eixo y',
          'O centro da parábola'
        ],
        correctAnswerIndex: 0,
        explanation: 'O vértice é o ponto de máximo (se a < 0) ou mínimo (se a > 0) da parábola.',
        type: QuestionType.quadratic,
      ),
      // Adicione mais questões aqui...
    ];
  }

  /// Gera opções padrão baseadas no tipo
  List<String> _generateDefaultOptions(QuestionType type) {
    if (type == QuestionType.linear) {
      return [
        'O coeficiente angular define a inclinação',
        'O gráfico é sempre uma parábola',
        'Não tem intercepto com o eixo y',
        'Sua derivada é sempre zero'
      ];
    } else {
      return [
        'O coeficiente a define a concavidade',
        'Seu gráfico é sempre uma reta',
        'Não possui vértice',
        'É uma função de primeiro grau'
      ];
    }
  }

  /// Gera explicações passo a passo (método existente)
  Future<String> generateStepByStepExplanation(
    String functionEquation,
    FunctionType functionType,
  ) async {
    try {
      final prompt = '''
Explique passo a passo a função: $functionEquation
Tipo: ${functionType == FunctionType.linear ? 'Função Linear' : 'Função Quadrática'}
Forneça uma explicação educativa em português.
''';

      final response = await _model.generateContent([Content.text(prompt)]);
      return response.text ?? 'Explicação não disponível.';
    } catch (e) {
      return 'Erro ao gerar explicação.';
    }
  }
}