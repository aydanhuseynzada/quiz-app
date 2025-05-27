import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/quiz_model.dart';

class QuizDataLoader {
  static Future<List<Quiz>> loadQuizzes() async {
    final String response = await rootBundle.loadString('assets/quiz_data.json');
    final data = json.decode(response);

    List<Quiz> quizzes = [];
    for (var quiz in data['quizzes']) {
      quizzes.add(Quiz.fromJson(quiz));
    }
    return quizzes;
  }
}