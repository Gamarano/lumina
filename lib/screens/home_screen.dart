import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Widget _menuButton(BuildContext c, String label, VoidCallback onTap) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(16)),
        child: Text(label, style: const TextStyle(fontSize: 18)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lumina — Funções em Jogo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 8),
            const Text(
              'Escolha um modo',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _menuButton(context, 'Quiz (1º / 2º grau)', () {
              // navegar para Quiz (ainda não implementado)
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Quiz: em desenvolvimento')),
              );
            }),
            const SizedBox(height: 8),
            _menuButton(context, 'Laboratório', () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Laboratório: em desenvolvimento')),
              );
            }),
            const SizedBox(height: 8),
            _menuButton(context, 'Aprenda Mais', () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Aprenda Mais: em desenvolvimento')),
              );
            }),
            const SizedBox(height: 8),
            _menuButton(context, 'Perfil', () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Perfil: em desenvolvimento')),
              );
            }),
            const SizedBox(height: 8),
            _menuButton(context, 'Configurações', () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Configurações: em desenvolvimento')),
              );
            }),
            const Spacer(),
            const Text('Versão inicial — Trabalho acadêmico'),
          ],
        ),
      ),
    );
  }
}
