import 'package:e_learning_management_system/models/EnrollmentModel.dart';
import 'package:e_learning_management_system/screens/ManualPaymentPage.dart';
import 'package:e_learning_management_system/services/EnrollmentService.dart';
import 'package:flutter/material.dart';

class StudentStatusCheck extends StatefulWidget {
  const StudentStatusCheck({super.key});

  @override
  State<StudentStatusCheck> createState() => _StudentStatusCheckState();
}

class _StudentStatusCheckState extends State<StudentStatusCheck> {
  final TextEditingController _emailController = TextEditingController();
  final EnrollmentService _enrollmentService = EnrollmentService();

  EnrollmentModel? _enrollment;
  bool _loading = false;
  String? _errorMessage;

  Future<void> _fetchStatus() async {
    setState(() {
      _loading = true;
      _errorMessage = null;
      _enrollment = null;
    });

    try {
      final enrollment = await _enrollmentService.getEnrollmentByEmail(
        _emailController.text.trim(),
      );
      setState(() {
        _enrollment = enrollment;
      });
    } catch (e) {
      setState(() {
        _errorMessage = "Failed to fetch enrollment status.";
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  Widget _buildStatusCard(EnrollmentModel enrollment) {
    Color cardColor;
    Color textColor;

    switch (enrollment.status?.toLowerCase()) {
      case 'approved':
        cardColor = Colors.green.shade100;
        textColor = Colors.green.shade900;
        break;
      case 'rejected':
        cardColor = Colors.red.shade100;
        textColor = Colors.red.shade900;
        break;
      default:
        cardColor = Colors.orange.shade100;
        textColor = Colors.orange.shade900;
    }

    return Card(
      color: cardColor,
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: Icon(Icons.school, color: textColor, size: 40),
              title: Text(
                enrollment.name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: textColor,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 6),
                  Text(
                    "Email: ${enrollment.email}",
                    style: TextStyle(color: textColor),
                  ),
                  Text(
                    "Status: ${enrollment.status ?? 'Pending'}",
                    style: TextStyle(color: textColor),
                  ),
                  Text(
                    "Course ID: ${enrollment.courseId != 0 ? enrollment.courseId : 'N/A'}",
                    style: TextStyle(color: textColor),
                  ),
                ],
              ),
            ),

            // Payment button only if approved
            if (enrollment.status?.toLowerCase() == 'approved') ...[
              const SizedBox(height: 10),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ManualPaymentPage(
                          email: enrollment
                              .email, // Pass the email to payment form
                        ),
                      ),
                    );
                  },

                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 12,
                    ),
                  ),
                  child: const Text(
                    "Proceed to Payment",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Check Enrollment Status"),
        backgroundColor: const Color.fromARGB(255, 5, 200, 239),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: "Enter your email",
                prefixIcon: const Icon(Icons.email),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: _fetchStatus,
              icon: const Icon(Icons.search),
              label: const Text("Check Status"),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 5, 118, 240),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 20),
            if (_loading)
              const CircularProgressIndicator()
            else if (_errorMessage != null)
              Text(_errorMessage!, style: const TextStyle(color: Colors.red))
            else if (_enrollment != null)
              _buildStatusCard(_enrollment!)
            else
              const Text("No enrollment found."),
          ],
        ),
      ),
    );
  }
}
