import 'dart:convert';
import 'package:http/http.dart' as http;

class UserService {
  final String baseUrl =
      "http://localhost:8080/api/auth"; // Use IP for real device

  Future<List<Map<String, dynamic>>> getAllUsers() async {
    final response = await http.get(Uri.parse("$baseUrl/users"));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(data);
    } else {
      throw Exception("Failed to load users");
    }
  }

  Future<void> updateUser(int id, Map<String, dynamic> updatedUser) async {
    final response = await http.put(
      Uri.parse("$baseUrl/users/$id"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(updatedUser),
    );
    if (response.statusCode != 200) {
      throw Exception("Failed to update user");
    }
  }

  Future<void> deleteUser(int id) async {
    final response = await http.delete(Uri.parse("$baseUrl/users/$id"));
    if (response.statusCode != 200) {
      throw Exception("Failed to delete user");
    }
  }
}
