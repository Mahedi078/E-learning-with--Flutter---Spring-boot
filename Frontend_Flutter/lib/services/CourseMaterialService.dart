import 'dart:convert';
import 'package:e_learning_management_system/models/CourseMaterial.dart';
import 'package:http/http.dart' as http;

class CourseMaterialService {
  static const String baseUrl = 'http://localhost:8080/api/materials';

  Future<List<CourseMaterial>> fetchMaterialsByCourse(int courseId) async {
    final response = await http.get(Uri.parse('$baseUrl/by-course/$courseId'));

    if (response.statusCode == 200) {
      List jsonData = json.decode(response.body);
      return jsonData.map((e) => CourseMaterial.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load materials');
    }
  }

  Future<bool> addMaterial(CourseMaterial material) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(material.toJson()),
    );
    return response.statusCode == 200 || response.statusCode == 201;
  }
}
