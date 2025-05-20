import 'package:flutter/material.dart';
import 'dart:async';
import '../models/quiz_model.dart';
import 'result_page.dart';

class QuizPage extends StatefulWidget {
  final Quiz quiz;

  const QuizPage({super.key, required this.quiz});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int _currentQuestionIndex = 0;
  int _selectedOptionIndex = -1;
  List<int> _userAnswers = [];
  int _timer = 20;
  Timer? _timerInstance;

  @override
  void initState() {
    super.initState();
    _userAnswers = List.filled(widget.quiz.questions.length, -1);
    _startTimer();
  }

  // Timer başlatmaq və əvvəlkini ləğv etmək
  void _startTimer() {
    _timerInstance?.cancel(); // Əvvəlki timeri ləğv et
    _timer = 20;
    _timerInstance = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timer > 0) {
        setState(() {
          _timer--;
        });
      } else {
        _nextQuestion();
      }
    });
  }

  void _nextQuestion() {
    _timerInstance?.cancel();

    if (_selectedOptionIndex == -1) {
      _userAnswers[_currentQuestionIndex] = -1;
    }

    if (_currentQuestionIndex < widget.quiz.questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _selectedOptionIndex = _userAnswers[_currentQuestionIndex];
      });
      _startTimer();
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ResultPage(
            quiz: widget.quiz,
            userAnswers: _userAnswers,
          ),
        ),
      );
    }
  }

  void _previousQuestion() {
    if (_currentQuestionIndex > 0) {
      _timerInstance?.cancel();
      setState(() {
        _currentQuestionIndex--;
        _selectedOptionIndex = _userAnswers[_currentQuestionIndex];
      });
      _startTimer();
    }
  }

  void _selectOption(int index) {
    setState(() {
      _selectedOptionIndex = index;
      _userAnswers[_currentQuestionIndex] = index;
    });
  }

  void _goToQuestion(int index) {
    _timerInstance?.cancel();
    setState(() {
      _currentQuestionIndex = index;
      _selectedOptionIndex = _userAnswers[_currentQuestionIndex];
    });
    _startTimer();
  }

  String _formatTime(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$secs';
  }

  @override
  void dispose() {
    _timerInstance?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final question = widget.quiz.questions[_currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.quiz.title),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Timer göstərilir
            Text(
              _formatTime(_timer),
              style: const TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 20),

            // Progress göstəricisi
            LinearProgressIndicator(
              value: (_currentQuestionIndex + 1) / widget.quiz.questions.length,
            ),
            const SizedBox(height: 8),

            Text(
              'Question ${_currentQuestionIndex + 1} of ${widget.quiz.questions.length}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),

            Text(
              question.question,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            if (question.imageUrl != null)
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    question.imageUrl!,
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 180,
                        width: double.infinity,
                        color: Colors.grey[300],
                        child: const Center(child: Text('Image not available')),
                      );
                    },
                  ),
                ),
              ),
            const SizedBox(height: 16),

            // Cavab variantları
            Expanded(
              child: ListView.builder(
                itemCount: question.options.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: OptionItem(
                      text: question.options[index],
                      isSelected: _selectedOptionIndex == index,
                      onTap: () => _selectOption(index),
                    ),
                  );
                },
              ),
            ),

            // Previous və Next düymələri
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _previousQuestion,
                  child: const Text('Previous'),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: _nextQuestion,
                  child: Text(
                    _currentQuestionIndex < widget.quiz.questions.length - 1
                        ? 'Next Question'
                        : 'Finish Quiz',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Sual nömrələri
            Wrap(
              alignment: WrapAlignment.center,
              children: List.generate(widget.quiz.questions.length, (index) {
                return GestureDetector(
                  onTap: () => _goToQuestion(index),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 4),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: _currentQuestionIndex == index
                          ? Colors.blue
                          : Colors.grey,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Text(
                      '${index + 1}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class OptionItem extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  const OptionItem({
    super.key,
    required this.text,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
          color: isSelected ? Colors.blue.withOpacity(0.1) : null,
        ),
        child: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? Colors.blue : Colors.grey,
                ),
                color: isSelected ? Colors.blue : null,
              ),
              child: isSelected
                  ? const Icon(
                      Icons.check,
                      size: 16,
                      color: Colors.white,
                    )
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(text)),
          ],
        ),
      ),
    );
  }
}

