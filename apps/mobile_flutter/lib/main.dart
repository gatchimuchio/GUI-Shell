import 'package:flutter/material.dart';

void main() {
  runApp(const GuiShellMobileApp());
}

class GuiShellMobileApp extends StatelessWidget {
  const GuiShellMobileApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GUI Shell Mobile',
      theme: ThemeData(useMaterial3: true),
      home: const Scaffold(
        body: Center(
          child: Text('GUI Shell Mobile Companion'),
        ),
      ),
    );
  }
}
