// lib/services/quiz_service.dart
import 'dart:convert';
import 'package:e_learning_management_system/screens/quiz_model.dart';
import 'package:http/http.dart' as http;

class QuizService {
  // change to your backend host if needed
  static const String baseUrl = 'http://localhost:8080/api/quizzes';

  Future<List<Quiz>> fetchAll() async {
    final res = await http.get(Uri.parse(baseUrl));
    if (res.statusCode == 200) {
      final List<dynamic> list = json.decode(res.body);
      return list.map((e) => Quiz.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load quizzes');
    }
  }

  Future<Quiz> fetchById(int id) async {
    final res = await http.get(Uri.parse('$baseUrl/$id'));
    if (res.statusCode == 200) {
      return Quiz.fromJson(json.decode(res.body));
    } else {
      throw Exception('Failed to load quiz');
    }
  }

  Future<bool> createQuiz(Quiz quiz) async {
    final res = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(quiz.toJson()),
    );
    return res.statusCode == 200 || res.statusCode == 201;
  }

  Future<Map<String, dynamic>> submitAnswers(
    int quizId,
    Map<int, String> answers,
  ) async {
    final Map<String, String> payload = {};
    answers.forEach((k, v) => payload[k.toString()] = v);

    final res = await http.post(
      Uri.parse('$baseUrl/$quizId/submit'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(payload),
    );

    if (res.statusCode == 200) {
      return json.decode(res.body) as Map<String, dynamic>;
    } else {
      throw Exception('Failed to submit quiz');
    }
  }
}
