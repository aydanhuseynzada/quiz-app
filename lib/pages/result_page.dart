import 'package:flutter/material.dart';

class ResultPage extends StatelessWidget {
  final int totalQuestions, correctAnswers;
  final VoidCallback onRestart;

  const ResultPage({
    super.key,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.onRestart,
  });

  @override
  Widget build(BuildContext context) {
    double score = totalQuestions > 0 ? correctAnswers / totalQuestions : 0.0;
    String message = score == 1.0 ? "Great job!" : score >= 0.6 ? "Well done!" : "Try again!";
    Color messageColor = score == 1.0 ? Colors.green : score >= 0.6 ? Colors.orange : Colors.red;

    return Scaffold(
      appBar: AppBar(title: const Text("Result")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Your Score: ${(score * 100).toStringAsFixed(0)}%", style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Text(message, style: TextStyle(fontSize: 20, color: messageColor)),
            ElevatedButton(onPressed: onRestart, child: const Text("Restart")),
          ],
        ),
      ),
    );
  }
}