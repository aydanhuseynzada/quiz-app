import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/quiz_model.dart';

class QuizDataLoader {
  static Future<List<Quiz>> loadQuizData() async {
    final String jsonString = await rootBundle.loadString('assets/quiz_data.json');
    final jsonData = json.decode(jsonString);
    
    List<Quiz> quizzes = (jsonData['quizzes'] as List)
        .map((quiz) => Quiz.fromJson(quiz))
        .toList();
    
    return quizzes;
  }
}
