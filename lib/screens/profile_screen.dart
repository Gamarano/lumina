import 'package:flutter/material.dart';
import 'package:lumina_funcoes_em_acao/models/user_model.dart';
import 'package:provider/provider.dart';
import '../controllers/user_controller.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meu Perfil'),
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => _showSettingsDialog(context),
          ),
        ],
      ),
      body: Consumer<UserController>(
        builder: (context, userController, child) {
          final user = userController.user;
          
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Cabeçalho do perfil
                _buildProfileHeader(user),
                const SizedBox(height: 30),
                
                // Estatísticas
                _buildStatisticsSection(user),
                const SizedBox(height: 30),
                
                // Medalhas
                _buildBadgesSection(user),
                const SizedBox(height: 30),
                
                // Funções estudadas
                _buildStudiedFunctionsSection(user),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileHeader(UserModel user) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            const CircleAvatar(
              radius: 40,
              backgroundColor: Colors.blue,
              child: Icon(
                Icons.person,
                size: 40,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Estudante de Matemática',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(Icons.emoji_events, color: Colors.amber, size: 20),
                      const SizedBox(width: 5),
                      Text(
                        '${user.points} pontos',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatisticsSection(UserModel user) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '📊 Estatísticas',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem('Pontos Totais', '${user.points}'),
                _buildStatItem('Medalhas', '${user.badges.length}'),
                _buildStatItem('Funções', '${user.studiedFunctions.length}'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildBadgesSection(UserModel user) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '🏆 Medalhas Conquistadas',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            if (user.badges.isEmpty)
              const Text(
                'Nenhuma medalha conquistada ainda. Continue estudando!',
                style: TextStyle(color: Colors.grey),
              )
            else
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: user.badges.map((badge) {
                  return Chip(
                    label: Text(badge),
                    backgroundColor: Colors.amber[100],
                    avatar: const Icon(Icons.emoji_events, color: Colors.amber),
                  );
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStudiedFunctionsSection(UserModel user) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '📚 Funções Estudadas',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            if (user.studiedFunctions.isEmpty)
              const Text(
                'Nenhuma função estudada ainda. Explore a tela de aprendizado!',
                style: TextStyle(color: Colors.grey),
              )
            else
              Column(
                children: user.studiedFunctions.map((function) {
                  return ListTile(
                    leading: const Icon(Icons.functions, color: Colors.blue),
                    title: Text(function),
                    trailing: const Icon(Icons.check_circle, color: Colors.green),
                  );
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }

  void _showSettingsDialog(BuildContext context) {
    final userController = Provider.of<UserController>(context, listen: false);
    final nameController = TextEditingController(text: userController.user.name);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Configurações'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Seu Nome',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                userController.updateName(nameController.text);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Nome atualizado com sucesso!')),
                );
              },
              child: const Text('Salvar Nome'),
            ),
            const SizedBox(height: 10),
            OutlinedButton(
              onPressed: () {
                userController.resetProgress();
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Progresso resetado!')),
                );
              },
              style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Resetar Progresso'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }
}