import 'package:flutter/material.dart';
import '../models/quiz_model.dart';

class WrongAnswersPage extends StatelessWidget {
  final Quiz quiz;
  final List<int> userAnswers;

  const WrongAnswersPage({
    super.key,
    required this.quiz,
    required this.userAnswers,
  });

  @override
  Widget build(BuildContext context) {
    final wrongAnswers = <Map<String, dynamic>>[];

    for (int i = 0; i < quiz.questions.length; i++) {
      if (userAnswers[i] != quiz.questions[i].correctIndex) {
        wrongAnswers.add({
          'question': quiz.questions[i].question,
          'userAnswer': quiz.questions[i].options[userAnswers[i]], // DÜZGÜN
          'correctAnswer': quiz.questions[i].options[quiz.questions[i].correctIndex], // DÜZGÜN
        });
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Wrong Answers'),
      ),
      body: ListView.builder(
        itemCount: wrongAnswers.length,
        itemBuilder: (context, index) {
          final item = wrongAnswers[index];
          return Card(
            margin: const EdgeInsets.all(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Q${index + 1}: ${item['question']}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text('Your Answer: ${item['userAnswer']}', style: const TextStyle(color: Colors.red)),
                  Text('Correct Answer: ${item['correctAnswer']}', style: const TextStyle(color: Colors.green)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}