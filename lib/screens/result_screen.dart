import 'package:flutter/material.dart';
import 'home_screen.dart';

class ResultScreen extends StatelessWidget {
  final int score;
  final int total;

  const ResultScreen({super.key, required this.score, required this.total});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Resultado')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Você acertou $score de $total questões!',
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeScreen()));
                },
                child: const Text('Voltar ao início'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
