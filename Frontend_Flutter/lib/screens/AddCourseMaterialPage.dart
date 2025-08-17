// import 'package:e_learning_management_system/models/CourseMaterial.dart';
// import 'package:e_learning_management_system/services/CourseMaterialService.dart';
// import 'package:flutter/material.dart';

// class AddCourseMaterialPage extends StatefulWidget {
//   final int courseId;

//   const AddCourseMaterialPage({Key? key, required this.courseId})
//     : super(key: key);

//   @override
//   State<AddCourseMaterialPage> createState() => _AddCourseMaterialPageState();
// }

// class _AddCourseMaterialPageState extends State<AddCourseMaterialPage> {
//   final _formKey = GlobalKey<FormState>();
//   String type = 'VIDEO';
//   String title = '';
//   String url = '';

//   void submitMaterial() async {
//     if (_formKey.currentState!.validate()) {
//       CourseMaterial material = CourseMaterial(
//         type: type,
//         title: title,
//         url: url,
//         courseId: widget.courseId,
//       );

//       bool success = await CourseMaterialService().addMaterial(material);

//       if (success) {
//         ScaffoldMessenger.of(
//           context,
//         ).showSnackBar(SnackBar(content: Text("Material added successfully")));
//         Navigator.pop(context);
//       } else {
//         ScaffoldMessenger.of(
//           context,
//         ).showSnackBar(SnackBar(content: Text("Failed to add material")));
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Add Course Material')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             children: [
//               DropdownButtonFormField<String>(
//                 value: type,
//                 items: ['VIDEO', 'PDF', 'DOC']
//                     .map((t) => DropdownMenuItem(value: t, child: Text(t)))
//                     .toList(),
//                 onChanged: (val) => setState(() => type = val!),
//                 decoration: InputDecoration(labelText: 'Material Type'),
//               ),
//               TextFormField(
//                 decoration: InputDecoration(labelText: 'Title'),
//                 onChanged: (val) => title = val,
//                 validator: (val) => val!.isEmpty ? 'Title required' : null,
//               ),
//               TextFormField(
//                 decoration: InputDecoration(labelText: 'URL or Path'),
//                 onChanged: (val) => url = val,
//                 validator: (val) => val!.isEmpty ? 'URL required' : null,
//               ),
//               SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: submitMaterial,
//                 child: Text("Add Material"),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:e_learning_management_system/models/CourseMaterial.dart';
import 'package:e_learning_management_system/services/CourseMaterialService.dart';
import 'package:flutter/material.dart';

class AddCourseMaterialPage extends StatefulWidget {
  final int courseId;

  const AddCourseMaterialPage({super.key, required this.courseId});

  @override
  State<AddCourseMaterialPage> createState() => _AddCourseMaterialPageState();
}

class _AddCourseMaterialPageState extends State<AddCourseMaterialPage> {
  final _formKey = GlobalKey<FormState>();
  String type = 'VIDEO';
  String title = '';
  String url = '';

  void submitMaterial() async {
    if (_formKey.currentState!.validate()) {
      CourseMaterial material = CourseMaterial(
        type: type,
        title: title,
        url: url,
        courseId: widget.courseId,
      );

      bool success = await CourseMaterialService().addMaterial(material);

      if (success) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Material added successfully")));
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Failed to add material")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Course Material')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            // Scroll added for smaller screens
            child: Column(
              children: [
                DropdownButtonFormField<String>(
                  value: type,
                  items: ['VIDEO', 'PDF', 'DOC']
                      .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                      .toList(),
                  onChanged: (val) => setState(() => type = val!),
                  decoration: InputDecoration(labelText: 'Material Type'),
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Title'),
                  onChanged: (val) => title = val,
                  validator: (val) => val!.isEmpty ? 'Title required' : null,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'URL or Path'),
                  onChanged: (val) => url = val,
                  validator: (val) => val!.isEmpty ? 'URL required' : null,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: submitMaterial,
                  child: Text("Add Material"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
