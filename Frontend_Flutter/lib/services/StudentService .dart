import 'dart:convert';
import 'dart:io';
import 'package:e_learning_management_system/models/StudentProfile.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

class StudentService {
  final String baseUrl = 'http://localhost:8080/api/students'; // Web compatible

  Future<void> autoCreateProfile(String email) async {
    final encodedEmail = Uri.encodeComponent(email);
    final response = await http.get(
      Uri.parse('$baseUrl/auto-create/$encodedEmail'),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to auto-create profile');
    }
  }

  Future<StudentProfile> getStudent(String email) async {
    final encodedEmail = Uri.encodeComponent(email);
    final response = await http.get(Uri.parse('$baseUrl/$encodedEmail'));
    if (response.statusCode == 200) {
      return StudentProfile.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Student not found');
    }
  }

  Future<void> updateProfileWithImage(
    StudentProfile student,
    File? imageFile,
  ) async {
    var request = http.MultipartRequest(
      'PUT',
      Uri.parse('$baseUrl/update-with-image'),
    );
    request.fields['email'] = student.email;
    request.fields['name'] = student.name;
    request.fields['age'] = student.age.toString();
    request.fields['course'] = student.course;

    if (imageFile != null) {
      String mimeType = lookupMimeType(imageFile.path) ?? 'image/jpeg';
      request.files.add(
        await http.MultipartFile.fromPath(
          'image',
          imageFile.path,
          contentType: MediaType.parse(mimeType),
        ),
      );
    }

    var response = await request.send();
    if (response.statusCode != 200) throw Exception('Failed to update profile');
  }

  String getImageUrl(String email) {
    final encodedEmail = Uri.encodeComponent(email);
    return '$baseUrl/image/$encodedEmail';
  }
}
