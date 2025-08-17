import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/course_model.dart';

class CourseService {
  static const String baseUrl = 'http://localhost:8080/api/courses';

  Future<List<Course>> fetchCourses() async {
    final response = await http.get(Uri.parse(baseUrl));
     print("Response: ${response.body}"); // ⬅️ Debug line
    if (response.statusCode == 200) {
      List data = json.decode(response.body);
      return data.map((json) => Course.fromJson(json)).toList();
// ⬅️ Debug line
    } else {
      throw Exception('Failed to load courses');
    }
  }

  Future<void> addCourse(Course course) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(course.toJson()),
    );
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to add course');
    }
  }

  Future<void> updateCourse(int id, Course course) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(course.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update course');
    }
  }

  Future<void> deleteCourse(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to delete course');
    }
  }
}
