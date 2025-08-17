import 'package:e_learning_management_system/models/EnrollmentModel.dart';
import 'package:e_learning_management_system/services/EnrollmentService.dart';
import 'package:flutter/material.dart';

class ManageEnrollmentsPage extends StatefulWidget {
  const ManageEnrollmentsPage({super.key});

  @override
  State<ManageEnrollmentsPage> createState() => _ManageEnrollmentsPageState();
}

class _ManageEnrollmentsPageState extends State<ManageEnrollmentsPage> {
  final EnrollmentService _enrollmentService = EnrollmentService();
  List<EnrollmentModel> _enrollments = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadEnrollments();
  }

  Future<void> _loadEnrollments() async {
    try {
      final data = await _enrollmentService.fetchEnrollments();
      setState(() {
        _enrollments = data;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error loading enrollments: $e")));
    }
  }

  Future<void> _handleAction(int id, bool approve) async {
    try {
      if (approve) {
        await _enrollmentService.approveEnrollment(id);
      } else {
        await _enrollmentService.rejectEnrollment(id);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Enrollment ${approve ? "approved" : "rejected"}"),
          backgroundColor: approve ? Colors.green : Colors.red,
        ),
      );

      _loadEnrollments(); // Reload after action
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Action failed: $e")));
    }
  }

  Widget _buildEnrollmentCard(EnrollmentModel e) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              e.name,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text("Email: ${e.email}"),
            Text("Phone: ${e.phone}"),
            Text("Location: ${e.location}"),
            Text("Course ID: ${e.courseId}"),
            Text("DOB: ${e.dob}"),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Chip(
                  label: Text(
                    e.status ?? "PENDING",
                    style: const TextStyle(color: Colors.white),
                  ),
                  backgroundColor: (e.status == "APPROVED")
                      ? Colors.green
                      : (e.status == "REJECTED")
                      ? Colors.red
                      : Colors.orange,
                ),
                if ((e.status ?? "PENDING") == "PENDING")
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.check, color: Colors.green),
                        tooltip: "Approve",
                        onPressed: () {
                          if (e.id != null) {
                            _handleAction(e.id!, true);
                          }
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.red),
                        tooltip: "Reject",
                        onPressed: () {
                          if (e.id != null) {
                            _handleAction(e.id!, false);
                          }
                        },
                      ),
                    ],
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Manage Student Enrollments"),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _enrollments.isEmpty
          ? const Center(child: Text("No enrollments found"))
          : RefreshIndicator(
              onRefresh: _loadEnrollments,
              child: ListView.builder(
                padding: const EdgeInsets.only(top: 8),
                itemCount: _enrollments.length,
                itemBuilder: (context, index) =>
                    _buildEnrollmentCard(_enrollments[index]),
              ),
            ),
    );
  }
}
