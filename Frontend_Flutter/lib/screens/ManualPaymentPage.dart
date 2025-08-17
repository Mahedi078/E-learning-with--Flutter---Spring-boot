import 'package:e_learning_management_system/models/manual_payment_model.dart';
import 'package:e_learning_management_system/services/manual_payment_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;

class ManualPaymentPage extends StatefulWidget {
  const ManualPaymentPage({super.key, required String email});

  @override
  State<ManualPaymentPage> createState() => _ManualPaymentPageState();
}

class _ManualPaymentPageState extends State<ManualPaymentPage> {
  final _formKey = GlobalKey<FormState>();
  final ManualPaymentService _paymentService = ManualPaymentService();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _methodController = TextEditingController();
  final TextEditingController _transactionIdController =
      TextEditingController();
  final TextEditingController _senderController = TextEditingController();

  bool _loading = false;
  String? _submitMessage;

  List<ManualPaymentModel> _payments = [];

  Future<void> _submitPayment() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _loading = true;
      _submitMessage = null;
    });

    try {
      final payment = ManualPaymentModel(
        email: _emailController.text.trim(),
        method: _methodController.text.trim(),
        transactionId: _transactionIdController.text.trim(),
        sender: _senderController.text.trim(),
        status: "PENDING",
      );

      final saved = await _paymentService.submitPayment(payment);

      if (saved != null) {
        setState(() {
          _submitMessage =
              "Payment submitted successfully and is pending approval.";
        });
        _loadPayments(); // Reload payment history after submit
      } else {
        setState(() {
          _submitMessage = "Failed to submit payment.";
        });
      }
    } catch (e) {
      setState(() {
        _submitMessage = "Error: $e";
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  Future<void> _loadPayments() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) return;

    final payments = await _paymentService.getPaymentsByEmail(email);
    setState(() {
      _payments = payments;
    });
  }

  void _printReceipt(ManualPaymentModel payment) {
    final dateFormatted = DateFormat(
      'yyyy-MM-dd HH:mm',
    ).format(payment.submittedAt);
    final receipt =
        '''
Payment Receipt
------------------------
Payment ID: ${payment.id}
Email: ${payment.email}
Method: ${payment.method}
Transaction ID: ${payment.transactionId}
Sender: ${payment.sender}
Status: ${payment.status}
Submitted At: $dateFormatted
------------------------
Thank you for your payment.
''';

    Printing.layoutPdf(
      onLayout: (format) async {
        final pdf = pw.Document();
        pdf.addPage(pw.Page(build: (context) => pw.Text(receipt)));
        return pdf.save();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Manual Payment"),
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Payment form
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: "Your Email",
                      prefixIcon: Icon(Icons.email),
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return "Please enter email";
                      }
                      if (!val.contains('@')) return "Enter valid email";
                      return null;
                    },
                    onChanged: (_) => _loadPayments(),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _methodController,
                    decoration: const InputDecoration(
                      labelText: "Payment Method (bKash/Nagad/etc.)",
                      prefixIcon: Icon(Icons.payment),
                      border: OutlineInputBorder(),
                    ),
                    validator: (val) => val == null || val.isEmpty
                        ? "Enter payment method"
                        : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _transactionIdController,
                    decoration: const InputDecoration(
                      labelText: "Transaction ID",
                      prefixIcon: Icon(Icons.confirmation_number),
                      border: OutlineInputBorder(),
                    ),
                    validator: (val) => val == null || val.isEmpty
                        ? "Enter transaction ID"
                        : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _senderController,
                    decoration: const InputDecoration(
                      labelText: "Sender Name",
                      prefixIcon: Icon(Icons.person),
                      border: OutlineInputBorder(),
                    ),
                    validator: (val) =>
                        val == null || val.isEmpty ? "Enter sender name" : null,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: _loading ? null : _submitPayment,
                    icon: const Icon(Icons.send),
                    label: const Text("Submit Payment"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.cyanAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  if (_submitMessage != null) ...[
                    const SizedBox(height: 12),
                    Text(
                      _submitMessage!,
                      style: TextStyle(
                        color: _submitMessage!.toLowerCase().contains("failed")
                            ? Colors.red
                            : Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Payment history list
            if (_payments.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Payment History",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const Divider(),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _payments.length,
                    itemBuilder: (context, index) {
                      final payment = _payments[index];
                      return Card(
                        elevation: 3,
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        child: ListTile(
                          leading: Icon(
                            payment.status.toLowerCase() == 'approved'
                                ? Icons.check_circle
                                : payment.status.toLowerCase() == 'pending'
                                ? Icons.hourglass_empty
                                : Icons.cancel,
                            color: payment.status.toLowerCase() == 'approved'
                                ? Colors.green
                                : payment.status.toLowerCase() == 'pending'
                                ? Colors.orange
                                : Colors.red,
                          ),
                          title: Text(
                            "Transaction ID: ${payment.transactionId}",
                          ),
                          subtitle: Text(
                            "Method: ${payment.method}\nStatus: ${payment.status}",
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.print),
                            onPressed: () => _printReceipt(payment),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
