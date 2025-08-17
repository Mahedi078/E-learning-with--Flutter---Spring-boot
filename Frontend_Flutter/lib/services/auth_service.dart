import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';

class AuthService {
  final String baseUrl = "http://localhost:8080/api/auth";

  Future<User?> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final userJson = jsonDecode(response.body);
        print("Login Success: $userJson");
        return User.fromJson(userJson);
      } else {
        print("Login failed: ${response.statusCode} => ${response.body}");
        return null;
      }
    } catch (e) {
      print("Login exception: $e");
      return null;
    }
  }

  Future<User?> register(User user) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(user.toJson()),
      );

      if (response.statusCode == 200) {
        final userJson = jsonDecode(response.body);
        print("Registration Success: $userJson");
        return User.fromJson(userJson);
      } else {
        print(
          "Registration failed: ${response.statusCode} => ${response.body}",
        );
        return null;
      }
    } catch (e) {
      print("Registration exception: $e");
      return null;
    }
  }
}
