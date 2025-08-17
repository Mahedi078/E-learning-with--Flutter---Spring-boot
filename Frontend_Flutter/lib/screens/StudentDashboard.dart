import 'package:e_learning_management_system/screens/StudentMyCoursesPage.dart';
import 'package:e_learning_management_system/screens/StudentProfileScreen.dart';
import 'package:e_learning_management_system/screens/available_courses_page.dart';
import 'package:e_learning_management_system/screens/student_quizzes_page.dart';
import 'package:e_learning_management_system/screens/student_status_check.dart';
import 'package:flutter/material.dart';
import '../widgets/dashboard_scaffold.dart';
import 'login_page.dart';

class StudentDashboard extends StatelessWidget {
  final String email;
  const StudentDashboard({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    return DashboardScaffold(
      title: 'Student Dashboard',
      drawerItems: [
        _buildDrawerItem(
          context,
          icon: Icons.dashboard,
          title: 'Dashboard Home',
          onTap: () => Navigator.pop(context),
        ),
        _buildDrawerItem(
          context,
          icon: Icons.play_circle_fill,
          title: 'Available Courses',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => AvailableCoursesPage()),
            );
          },
        ),

        _buildDrawerItem(
          context,
          icon: Icons.play_circle_fill,
          title: 'Check Status',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => StudentStatusCheck()),
            );
          },
        ),

        _buildDrawerItem(
          context,
          icon: Icons.play_circle_fill,
          title: 'My Courses',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => StudentMyCoursesPage(email: email),
              ),
            );
          },
        ),

        _buildDrawerItem(
          context,
          icon: Icons.quiz,
          title: 'My Quizzes',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => StudentQuizzesPage()),
            );
            // TODO: Navigate to Quizzes Page
          },
        ),
        _buildDrawerItem(
          context,
          icon: Icons.person,
          title: 'My Profile',
          onTap: () {
            Navigator.pop(context); // drawer close
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => StudentProfileScreen(email: email),
              ),
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
                  'Welcome, Student!',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo[900],
                  ),
                ),
                const SizedBox(height: 24),

                // Responsive Stat Cards
                Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    _buildStatCard(
                      title: 'Enrolled Courses',
                      count: '4',
                      icon: Icons.school,
                      color: Colors.deepPurple,
                      width: constraints.maxWidth < 600
                          ? constraints.maxWidth
                          : 260,
                    ),
                    _buildStatCard(
                      title: 'Completed Quizzes',
                      count: '10',
                      icon: Icons.check_circle,
                      color: Colors.teal,
                      width: constraints.maxWidth < 600
                          ? constraints.maxWidth
                          : 260,
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Notification Card
                Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: Icon(
                      Icons.notifications_active,
                      color: Colors.orange,
                      size: 30,
                    ),
                    title: Text('Upcoming Quiz'),
                    subtitle: Text('Math Basics - Aug 2, 2025'),
                    trailing: Icon(Icons.arrow_forward_ios, size: 18),
                    onTap: () {
                      // TODO: Navigate to quiz details
                    },
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

  /// Dashboard Card
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
