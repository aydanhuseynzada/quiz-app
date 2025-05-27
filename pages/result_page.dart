import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'dart:math';
import '../models/quiz_model.dart';
import 'quiz_page.dart';
import 'wrong_answers_page.dart';

class ResultPage extends StatefulWidget {
  final Quiz quiz;
  final List<int> userAnswers;

  const ResultPage({
    super.key,
    required this.quiz,
    required this.userAnswers,
  });

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  late final ConfettiController _confettiController;

  int get correctAnswersCount {
    int count = 0;
    for (int i = 0; i < widget.quiz.questions.length; i++) {
      if (widget.userAnswers[i] == widget.quiz.questions[i].correctIndex) {
        count++;
      }
    }
    return count;
  }

  double get scorePercentage => (correctAnswersCount / widget.quiz.questions.length) * 100;

  String get feedbackMessage {
    if (scorePercentage >= 80) {
      return 'Excellent! You\'re a quiz master!';
    } else if (scorePercentage >= 60) {
      return 'Good job! You\'re doing well!';
    } else if (scorePercentage >= 40) {
      return 'Not bad! Keep learning!';
    } else {
      return 'Keep practicing! You\'ll improve!';
    }
  }

  Color _getScoreColor() {
    if (scorePercentage >= 80) {
      return Colors.green;
    } else if (scorePercentage >= 60) {
      return Colors.blue;
    } else if (scorePercentage >= 40) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 3));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scorePercentage >= 75) {
        _confettiController.play();
      }
    });
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz Results'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Score circle
                Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: _getScoreColor(),
                      width: 8,
                    ),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${scorePercentage.toStringAsFixed(0)}%',
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: _getScoreColor(),
                          ),
                        ),
                        Text(
                          '$correctAnswersCount/${widget.quiz.questions.length}',
                          style: const TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // Feedback message
                Text(
                  feedbackMessage,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),

                // Quiz summary
                Text(
                  'You got $correctAnswersCount out of ${widget.quiz.questions.length} questions correct',
                  style: const TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),

                // Action buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      icon: const Icon(Icons.refresh),
                      label: const Text('Restart Quiz'),
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => QuizPage(quiz: widget.quiz),
                          ),
                        );
                      },
                    ),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.home),
                      label: const Text('Back to Home'),
                      onPressed: () {
                        Navigator.popUntil(context, (route) => route.isFirst);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // View Wrong Answers button
                if (correctAnswersCount < widget.quiz.questions.length)
                  ElevatedButton.icon(
                    icon: const Icon(Icons.error_outline),
                    label: const Text('View Wrong Answers'),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WrongAnswersPage(
                            quiz: widget.quiz,
                            userAnswers: widget.userAnswers,
                          ),
                        ),
                      );
                    },
                  ),
              ],
            ),
          ),

          // Confetti
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirection: pi / 2,
              emissionFrequency: 0.05,
              numberOfParticles: scorePercentage >= 100 ? 50 : 20,
              gravity: 0.1,
              shouldLoop: false,
            ),
          ),
        ],
      ),
    );
  }
}