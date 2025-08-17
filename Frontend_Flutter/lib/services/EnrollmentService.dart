import 'dart:convert';
import 'package:e_learning_management_system/models/EnrollmentModel.dart';
import 'package:e_learning_management_system/models/course_model.dart';

import 'package:http/http.dart' as http;

class EnrollmentService {
  final String baseUrl = "http://localhost:8080/api/enrollments";

  // 🟢 POST request to enroll student
  Future<bool> enrollStudent(EnrollmentModel model) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(model.toJson()),
    );
    return response.statusCode == 200 || response.statusCode == 201;
  }

  Future<List<Course>> getStudentCourses(String email) async {
    final response = await http.get(Uri.parse('$baseUrl/courses/$email'));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => Course.fromJson(item)).toList();
    } else {
      throw Exception('Failed to fetch student courses');
    }
  }

  // 🟣 GET all enrollments
  Future<List<EnrollmentModel>> fetchEnrollments() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((e) => EnrollmentModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load enrollments');
    }
  }

  // ✅ Approve enrollment by ID
  Future<void> approveEnrollment(int id) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$id/approve'),
      headers: {"Content-Type": "application/json"},
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to approve enrollment');
    }
  }

  // ✅ Reject enrollment by ID
  Future<void> rejectEnrollment(int id) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$id/reject'),
      headers: {"Content-Type": "application/json"},
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to reject enrollment');
    }
  }

  // ✅ NEW: Get enrollment by email
  Future<EnrollmentModel?> getEnrollmentByEmail(String email) async {
    final response = await http.get(Uri.parse('$baseUrl/by-email/$email'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return EnrollmentModel.fromJson(data);
    } else if (response.statusCode == 404) {
      return null; // Not found
    } else {
      throw Exception('Failed to fetch enrollment by email');
    }
  }
}
