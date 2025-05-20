class Option {
  final String text;
  
  Option({required this.text});
  
  factory Option.fromJson(Map<String, dynamic> json) {
    return Option(
      text: json['text'],
    );
  }
}

class Question {
  final String question;
  final List<String> options;
  final int correctIndex;
  final String? imageUrl;
  
  Question({
    required this.question,
    required this.options,
    required this.correctIndex,
    this.imageUrl,
  });
  
  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      question: json['question'],
      options: List<String>.from(json['options']),
      correctIndex: json['correctIndex'],
      imageUrl: json['imageUrl'],
    );
  }
}

class Quiz {
  final String title;
  final String description;
  final List<Question> questions;
  
  Quiz({
    required this.title,
    required this.description,
    required this.questions,
  });
  
  factory Quiz.fromJson(Map<String, dynamic> json) {
    return Quiz(
      title: json['title'],
      description: json['description'],
      questions: (json['questions'] as List)
          .map((q) => Question.fromJson(q))
          .toList(),
    );
  }
}
