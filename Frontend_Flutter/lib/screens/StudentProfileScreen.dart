import 'dart:io';

import 'package:e_learning_management_system/services/StudentService%20.dart';
import 'package:flutter/material.dart';

import 'package:e_learning_management_system/models/StudentProfile.dart';
import 'package:image_picker/image_picker.dart';

class StudentProfileScreen extends StatefulWidget {
  final String email;
  const StudentProfileScreen({super.key, required this.email});

  @override
  _StudentProfileScreenState createState() => _StudentProfileScreenState();
}

class _StudentProfileScreenState extends State<StudentProfileScreen> {
  late Future<StudentProfile> studentFuture;
  final studentService = StudentService();
  File? pickedImage;

  late TextEditingController nameController;
  late TextEditingController ageController;
  late TextEditingController courseController;

  @override
  void initState() {
    super.initState();
    studentFuture = studentService.getStudent(widget.email); // temp init
    _loadProfile();
  }

  void _loadProfile() async {
    await studentService.autoCreateProfile(widget.email);
    setState(() {
      studentFuture = studentService.getStudent(widget.email);
    });
    studentFuture.then((student) {
      nameController = TextEditingController(text: student.name);
      ageController = TextEditingController(text: student.age.toString());
      courseController = TextEditingController(text: student.course);
    });
  }

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
    ); // gallery থেকে
    if (image != null) {
      pickedImage = File(image.path);
    }
  }

  Future<void> _updateProfile(StudentProfile student) async {
    student.name = nameController.text;
    student.age = int.tryParse(ageController.text) ?? 0;
    student.course = courseController.text;

    await studentService.updateProfileWithImage(student, pickedImage);
    _loadProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Student Profile")),
      body: FutureBuilder<StudentProfile>(
        future: studentFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          StudentProfile student = snapshot.data!;
          return SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundImage: pickedImage != null
                      ? FileImage(pickedImage!)
                      : (student.imageUrl != null
                            ? NetworkImage(
                                "http://localhost:8080/uploads/${student.imageUrl}",
                              )
                            : AssetImage("assets/default.png")
                                  as ImageProvider),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: "Name"),
                ),
                TextField(
                  controller: ageController,
                  decoration: InputDecoration(labelText: "Age"),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: courseController,
                  decoration: InputDecoration(labelText: "Course"),
                ),
                SizedBox(height: 10),
                ElevatedButton.icon(
                  onPressed: pickImage,
                  icon: Icon(Icons.image),
                  label: Text("Pick Image"),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () => _updateProfile(student),
                  child: Text("Update Profile"),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
