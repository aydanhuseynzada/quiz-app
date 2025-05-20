import 'package:flutter/material.dart';
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
  
  @override
  void initState() {
    super.initState();
    _userAnswers = List.filled(widget.quiz.questions.length, -1);
  }
  
  void _selectOption(int index) {
    setState(() {
      _selectedOptionIndex = index;
      _userAnswers[_currentQuestionIndex] = index;
    });
  }
  
  void _nextQuestion() {
    if (_selectedOptionIndex == -1) {
      // Show a message to select an option
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an answer')),
      );
      return;
    }
    
    if (_currentQuestionIndex < widget.quiz.questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _selectedOptionIndex = _userAnswers[_currentQuestionIndex];
      });
    } else {
      // Navigate to results page
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Progress indicator
            LinearProgressIndicator(
              value: (_currentQuestionIndex + 1) / widget.quiz.questions.length,
            ),
            const SizedBox(height: 8),
            Text(
              'Question ${_currentQuestionIndex + 1} of ${widget.quiz.questions.length}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            
            // Question text
            Text(
              question.question,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            // Question image (if available)
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
            
            // Options
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
            
            // Next button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _nextQuestion,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: Text(
                  _currentQuestionIndex < widget.quiz.questions.length - 1
                      ? 'Next Question'
                      : 'Finish Quiz',
                ),
              ),
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