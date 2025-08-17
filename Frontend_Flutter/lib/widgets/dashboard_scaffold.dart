import 'package:flutter/material.dart';

class DashboardScaffold extends StatelessWidget {
  final String title;
  final Widget body;
  final List<Widget> drawerItems;

  const DashboardScaffold({super.key, 
    required this.title,
    required this.body,
    required this.drawerItems,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.deepPurple,
      ),
      drawer: Drawer(
        child: Container(
          color: Colors.deepPurple.shade100,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.deepPurple,
                ),
                child: Center(
                  child: Text(
                    'E-Learning Management',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                ),
              ),
              ...drawerItems,
            ],
          ),
        ),
      ),
      body: body,
    );
  }
}
