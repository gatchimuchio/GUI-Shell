import 'package:flutter/material.dart';

void main() {
  runApp(const GuiShellDesktopApp());
}

class GuiShellDesktopApp extends StatelessWidget {
  const GuiShellDesktopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GUI Shell',
      theme: ThemeData(useMaterial3: true),
      home: const ShellHomePage(),
    );
  }
}

class ShellHomePage extends StatelessWidget {
  const ShellHomePage({super.key});

  static const cards = [
    'Setup Doctor',
    'Runtime Center',
    'Permission Center',
    'Approval Center',
    'Audit Viewer',
    'Recovery Center',
    'Settings',
    'Framework Risk',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('GUI Shell')),
      body: GridView.count(
        padding: const EdgeInsets.all(16),
        crossAxisCount: 2,
        childAspectRatio: 2.6,
        children: [
          for (final card in cards)
            Card(
              child: Center(
                child: Text(
                  card,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
