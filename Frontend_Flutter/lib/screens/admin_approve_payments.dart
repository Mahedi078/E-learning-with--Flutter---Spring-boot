import 'dart:convert';

import 'package:e_learning_management_system/models/manual_payment_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AdminApprovePaymentsScreen extends StatefulWidget {
  const AdminApprovePaymentsScreen({super.key});

  @override
  _AdminApprovePaymentsScreenState createState() =>
      _AdminApprovePaymentsScreenState();
}

class _AdminApprovePaymentsScreenState
    extends State<AdminApprovePaymentsScreen> {
  List<ManualPaymentModel> pendingPayments = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchPendingPayments();
  }

  Future<void> fetchPendingPayments() async {
    final response = await http.get(
      Uri.parse('http://localhost:8080/api/manual-payment/pending'),
    );

    if (response.statusCode == 200) {
      List jsonList = jsonDecode(response.body);
      setState(() {
        pendingPayments = jsonList
            .map((e) => ManualPaymentModel.fromJson(e))
            .toList();
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to load payments')));
    }
  }

  Future<void> approvePayment(int id) async {
    final response = await http.put(
      Uri.parse(
        'http://localhost:8080/api/manual-payment/approve/$id?status=APPROVED',
      ),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Payment approved')));
      fetchPendingPayments(); // Refresh list
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Approval failed')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Pending Payments')),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : pendingPayments.isEmpty
          ? Center(child: Text('No pending payments'))
          : ListView.builder(
              itemCount: pendingPayments.length,
              itemBuilder: (context, index) {
                final payment = pendingPayments[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  elevation: 3,
                  child: ListTile(
                    title: Text("Email: ${payment.email}"),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Amount: ${payment.amount}"),
                        Text("Method: ${payment.method}"),
                        Text("Transaction ID: ${payment.transactionId}"),
                        Text("Sender: ${payment.sender}"),
                      ],
                    ),
                    trailing: ElevatedButton(
                      onPressed: () => approvePayment(payment.id!),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                      child: Text('Approve'),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
