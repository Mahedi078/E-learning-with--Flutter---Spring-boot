// lib/models/quiz_model.dart
class Quiz {
  final int? id;
  final String title;
  final String? description;
  final List<Question> questions;

  Quiz({
    this.id,
    required this.title,
    this.description,
    required this.questions,
  });

  factory Quiz.fromJson(Map<String, dynamic> json) {
    return Quiz(
      id: json['id'] != null ? (json['id'] as num).toInt() : null,
      title: json['title'] ?? '',
      description: json['description'],
      questions:
          (json['questions'] as List<dynamic>?)
              ?.map((q) => Question.fromJson(q as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
    if (id != null) "id": id,
    "title": title,
    "description": description,
    "questions": questions.map((q) => q.toJson()).toList(),
  };
}

class Question {
  final int? id;
  final String questionText;
  final String optionA;
  final String optionB;
  final String optionC;
  final String optionD;
  final String? correctOption;

  Question({
    this.id,
    required this.questionText,
    required this.optionA,
    required this.optionB,
    required this.optionC,
    required this.optionD,
    this.correctOption,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'] != null ? (json['id'] as num).toInt() : null,
      questionText: json['questionText'] ?? '',
      optionA: json['optionA'] ?? '',
      optionB: json['optionB'] ?? '',
      optionC: json['optionC'] ?? '',
      optionD: json['optionD'] ?? '',
      correctOption: json['correctOption'],
    );
  }

  Map<String, dynamic> toJson() => {
    if (id != null) 'id': id,
    'questionText': questionText,
    'optionA': optionA,
    'optionB': optionB,
    'optionC': optionC,
    'optionD': optionD,
    if (correctOption != null) 'correctOption': correctOption,
  };
}
