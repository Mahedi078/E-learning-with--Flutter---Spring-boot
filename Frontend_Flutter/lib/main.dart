import 'package:e_learning_management_system/screens/login_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'E-Learning App',
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      home: LoginPage(),
    ),
  );
}
