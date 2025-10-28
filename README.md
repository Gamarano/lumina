# 🔬 Lumina - Funções em Ação

## 📋 Sobre o Projeto

**Lumina - Funções em Ação** é um aplicativo educacional interativo desenvolvido em Flutter para o ensino de funções matemáticas de primeiro e segundo grau. O projeto faz parte de uma pesquisa acadêmica em Educação Matemática que visa validar o impacto pedagógico de aplicativos interativos no aprendizado.

### 🎯 Objetivo da Pesquisa
Comparar a eficácia do ensino tradicional versus o uso de aplicativos interativos gamificados no aprendizado de funções matemáticas no ensino médio.

## 🏗️ Arquitetura do Projeto
lib/
├── main.dart # Ponto de entrada do aplicativo
├── screens/ # Telas do aplicativo
│ ├── home_screen.dart # Tela inicial
│ ├── learn_screen.dart # Tela de aprendizado interativo
│ ├── quiz_screen.dart # Tela de quiz gamificado
│ └── profile_screen.dart # Tela de perfil e progresso
├── models/ # Modelos de dados
│ ├── user_model.dart # Modelo do usuário
│ ├── function_model.dart # Modelo de funções matemáticas
│ └── quiz_model.dart # Modelo de questões e resultados
├── controllers/ # Controladores de estado
│ ├── user_controller.dart # Gerenciamento do usuário
│ ├── function_controller.dart # Gerenciamento das funções
│ └── quiz_controller.dart # Gerenciamento do quiz
├── services/ # Serviços externos
│ ├── gemini_service.dart # Integração com Google Gemini AI
│ └── storage_service.dart # Armazenamento local
├── widgets/ # Componentes reutilizáveis
│ ├── function_graph.dart # Widget do gráfico interativo
│ ├── slider_controls.dart # Controles deslizantes
│ └── quiz_card.dart # Cartão de questão
└── utils/
└── constants.dart # Constantes e configurações

text

## 🚀 Funcionalidades Implementadas

### 1. 🎓 Aprendizado Interativo
- **Visualização de Gráficos**: Gráficos interativos de funções lineares e quadráticas
- **Manipulação em Tempo Real**: Sliders e campos de texto para ajustar coeficientes
- **Feedback Visual**: Mudanças instantâneas no gráfico conforme parâmetros são alterados
- **Explicações Contextuais**: Informações pedagógicas sobre cada coeficiente

### 2. 🎯 Sistema de Quiz Gamificado
- **Questões Geradas por IA**: Integração com Google Gemini AI para criação dinâmica de questões
- **Sistema de Pontuação**: +10 por acerto, -5 por erro
- **Medalhas e Conquistas**: Sistema de recompensas por progresso
- **Feedback Imediato**: Explicações detalhadas para cada resposta

### 3. 📊 Acompanhamento de Progresso
- **Perfil do Usuário**: Armazenamento local do progresso
- **Estatísticas Detalhadas**: Pontuação, medalhas, funções estudadas
- **Histórico de Aprendizado**: Registro de todas as funções exploradas

### 4. 🎨 Interface Moderna e Acessível
- **Design Responsivo**: Adaptável para celulares e tablets
- **Cores Suaves**: Paleta de cores pensada para concentração
- **Tipografia Legível**: Fontes otimizadas para leitura
- **Navegação Intuitiva**: Fluxo de uso simples e direto

## 🔧 Tecnologias Utilizadas

| Tecnologia | Versão | Propósito |
|------------|--------|-----------|
| Flutter | 3.0+ | Framework principal |
| Dart | 3.0+ | Linguagem de programação |
| Provider | ^6.1.1 | Gerenciamento de estado |
| FL Chart | ^0.60.1 | Gráficos interativos |
| Shared Preferences | ^2.2.2 | Armazenamento local |
| Google Generative AI | ^0.2.1 | Integração com Gemini AI |
| Google Fonts | ^4.0.4 | Tipografia moderna |

## ⚙️ Configuração do Ambiente

### Pré-requisitos
- Flutter SDK 3.0+
- Dart 3.0+
- Android Studio / VS Code
- Dispositivo Android/iOS ou emulador

### Configuração da API Gemini
1. Acesse [Google AI Studio](https://makersuite.google.com/app/apikey)
2. Crie uma conta e gere uma API Key
3. No arquivo `lib/services/gemini_service.dart`, substitua:
```dart
static const String _apiKey = 'SUA_API_KEY_AQUI';