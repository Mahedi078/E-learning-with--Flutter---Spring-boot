import 'package:e_learning_management_system/models/course_model.dart';
import 'package:flutter/material.dart';

import '../services/course_service.dart';

class ManageCoursesPage extends StatefulWidget {
  const ManageCoursesPage({super.key});

  @override
  State<ManageCoursesPage> createState() => _ManageCoursesPageState();
}

class _ManageCoursesPageState extends State<ManageCoursesPage> {
  final CourseService _courseService = CourseService();
  List<Course> _courses = [];

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _teacherIdController = TextEditingController();
  final TextEditingController _categoryIdController = TextEditingController();
  final TextEditingController _statusController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  bool _isEditing = false;
  Course? _editingCourse;

  @override
  void initState() {
    super.initState();
    _loadCourses();
  }

  void _loadCourses() async {
    final data = await _courseService.fetchCourses();
    setState(() => _courses = data);
  }

  void _saveCourse() async {
    Course newCourse = Course(
      title: _titleController.text,
      description: _descController.text,
      teacherId: int.tryParse(_teacherIdController.text) ?? 0,
      categoryId: int.tryParse(_categoryIdController.text) ?? 0,
      status: _statusController.text,
      price: double.tryParse(_priceController.text) ?? 0.0,
    );

    if (_isEditing && _editingCourse != null) {
      await _courseService.updateCourse(_editingCourse!.id!, newCourse);
    } else {
      await _courseService.addCourse(newCourse);
    }

    _clearForm();
    _loadCourses();
  }

  void _editCourse(Course course) {
    setState(() {
      _isEditing = true;
      _editingCourse = course;

      _titleController.text = course.title!;
      _descController.text = course.description!;
      _teacherIdController.text = course.teacherId.toString();
      _categoryIdController.text = course.categoryId.toString();
      _statusController.text = course.status!;
      _priceController.text = course.price.toString();
    });
  }

  void _deleteCourse(int id) async {
    await _courseService.deleteCourse(id);
    _loadCourses();
  }

  void _clearForm() {
    _titleController.clear();
    _descController.clear();
    _teacherIdController.clear();
    _categoryIdController.clear();
    _statusController.clear();
    _priceController.clear();
    setState(() {
      _isEditing = false;
      _editingCourse = null;
    });
  }

  Widget _buildCourseForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _titleController,
          decoration: InputDecoration(labelText: 'Title'),
        ),
        TextField(
          controller: _descController,
          decoration: InputDecoration(labelText: 'Description'),
        ),
        TextField(
          controller: _teacherIdController,
          decoration: InputDecoration(labelText: 'Teacher ID'),
        ),
        TextField(
          controller: _categoryIdController,
          decoration: InputDecoration(labelText: 'Category ID'),
        ),
        TextField(
          controller: _statusController,
          decoration: InputDecoration(labelText: 'Status'),
        ),
        TextField(
          controller: _priceController,
          decoration: InputDecoration(labelText: 'Price'),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: _saveCourse,
          child: Text(_isEditing ? 'Update Course' : 'Add Course'),
        ),
        if (_isEditing)
          TextButton(onPressed: _clearForm, child: const Text('Cancel Edit')),
      ],
    );
  }

  Widget _buildCourseList() {
    return Expanded(
      child: ListView.builder(
        itemCount: _courses.length,
        itemBuilder: (context, index) {
          final course = _courses[index];
          return Card(
            child: ListTile(
              title: Text(course.title.toString()),
              subtitle: Text(
                'Teacher ID: ${course.teacherId}, Category ID: ${course.categoryId}',
              ),
              trailing: Wrap(
                children: [
                  IconButton(
                    icon: Icon(Icons.edit, color: Colors.blue),
                    onPressed: () => _editCourse(course),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deleteCourse(course.id!),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Manage Courses")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildCourseForm(),
            const SizedBox(height: 20),
            _buildCourseList(),
          ],
        ),
      ),
    );
  }
}
