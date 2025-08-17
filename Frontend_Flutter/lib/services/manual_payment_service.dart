import 'dart:convert';
import 'package:e_learning_management_system/models/manual_payment_model.dart';
import 'package:http/http.dart' as http;

class ManualPaymentService {
  final String baseUrl = "http://localhost:8080/api/manual-payment";

  Future<ManualPaymentModel?> submitPayment(ManualPaymentModel payment) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(payment.toJson()),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return ManualPaymentModel.fromJson(jsonDecode(response.body));
    } else {
      return null;
    }
  }

  Future<List<ManualPaymentModel>> getPaymentsByEmail(String email) async {
    final response = await http.get(Uri.parse('$baseUrl/by-email/$email'));
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => ManualPaymentModel.fromJson(json)).toList();
    } else {
      return [];
    }
  }
}
