import 'package:e_learning_management_system/screens/ManageEnrollmentsPage.dart';
import 'package:e_learning_management_system/screens/SelectCourseForMaterialPage%20.dart';
import 'package:e_learning_management_system/screens/admin_approve_payments.dart';
import 'package:e_learning_management_system/screens/admin_create_quiz_page.dart';
import 'package:e_learning_management_system/screens/manage_courses_page.dart';
import 'package:flutter/material.dart';
import '../widgets/dashboard_scaffold.dart';
import 'ManageUsersPage.dart';
import 'login_page.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return DashboardScaffold(
      title: 'Admin Dashboard',
      drawerItems: [
        _buildDrawerItem(
          context,
          icon: Icons.dashboard,
          title: 'Dashboard Home',
          onTap: () => Navigator.pop(context),
        ),
        _buildDrawerItem(
          context,
          icon: Icons.group,
          title: 'Manage Users',
          onTap: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => ManageUsersPage()),
            );
          },
        ),
        _buildDrawerItem(
          context,
          icon: Icons.book,
          title: 'Manage Courses',
          onTap: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => ManageCoursesPage()),
            );
          },
        ),

        _buildDrawerItem(
          context,
          icon: Icons.book,
          title: 'Manage Enrollment',
          onTap: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => ManageEnrollmentsPage()),
            );
          },
        ),

        _buildDrawerItem(
          context,
          icon: Icons.book,
          title: 'Manage Payment',
          onTap: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => AdminApprovePaymentsScreen()),
            );
          },
        ),

        _buildDrawerItem(
          context,
          icon: Icons.book,
          title: 'Add Course Materials',
          onTap: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => SelectCourseForMaterialPage()),
            );
          },
        ),

          _buildDrawerItem(
          context,
          icon: Icons.book,
          title: 'Add Quizzes',
          onTap: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => AdminCreateQuizPage()),
            );
          },
        ),

        _buildDrawerItem(
          context,
          icon: Icons.logout,
          title: 'Logout',
          onTap: () {
            Navigator.pop(context);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => LoginPage()),
            );
          },
        ),
      ],
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome, Admin!',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo[900],
                  ),
                ),
                const SizedBox(height: 24),

                // Stat Cards
                Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    _buildStatCard(
                      title: 'Total Users',
                      count: '150',
                      icon: Icons.group,
                      color: Colors.blue,
                      width: constraints.maxWidth < 600
                          ? constraints.maxWidth
                          : 260,
                    ),
                    _buildStatCard(
                      title: 'Total Courses',
                      count: '25',
                      icon: Icons.book,
                      color: Colors.green,
                      width: constraints.maxWidth < 600
                          ? constraints.maxWidth
                          : 260,
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Activity Card
                Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: Icon(
                      Icons.notifications,
                      color: Colors.orange,
                      size: 30,
                    ),
                    title: Text('System Status'),
                    subtitle: Text('Everything is running smoothly.'),
                    trailing: Icon(Icons.arrow_forward_ios, size: 18),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  /// Drawer Item Builder
  Widget _buildDrawerItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.indigo),
      title: Text(title, style: TextStyle(fontSize: 16)),
      onTap: onTap,
    );
  }

  /// Stat Card Builder
  Widget _buildStatCard({
    required String title,
    required String count,
    required IconData icon,
    required Color color,
    required double width,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: width,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(height: 12),
            Text(
              count,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
