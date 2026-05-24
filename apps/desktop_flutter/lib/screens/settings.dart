import 'package:flutter/material.dart';

import '../services/shell_core_client.dart';
import 'shared.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key, required this.client});

  final ShellCoreClient client;

  @override
  Widget build(BuildContext context) {
    return const ShellPage(
      title: 'Settings',
      children: [
        SectionList(title: 'Runtime Connection', rows: ['Adapter transport: mock/http boundary', 'Authority source: Shell Core']),
        SectionList(title: 'Update Policy', rows: ['Signature required', 'Rollback enabled placeholder']),
        SectionList(title: 'Framework Risk', rows: ['Flutter isolated to UI app', 'Shell Core remains framework independent']),
      ],
    );
  }
}
