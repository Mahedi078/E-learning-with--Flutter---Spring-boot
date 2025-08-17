// Create a new page jekhane course list thakbe
import 'package:e_learning_management_system/models/course_model.dart';
import 'package:e_learning_management_system/screens/AddCourseMaterialPage.dart';
import 'package:e_learning_management_system/services/course_service.dart';
import 'package:flutter/material.dart';

class SelectCourseForMaterialPage extends StatefulWidget {
  const SelectCourseForMaterialPage({super.key});

  @override
  _SelectCourseForMaterialPageState createState() =>
      _SelectCourseForMaterialPageState();
}

class _SelectCourseForMaterialPageState
    extends State<SelectCourseForMaterialPage> {
  List<Course> courses = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadCourses();
  }

  void loadCourses() async {
    courses = await CourseService().fetchCourses();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Select Course")),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: courses.length,
              itemBuilder: (context, index) {
                final course = courses[index];
                return ListTile(
                  title: Text(course.title ?? "No Title"),
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            AddCourseMaterialPage(courseId: course.id!),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
