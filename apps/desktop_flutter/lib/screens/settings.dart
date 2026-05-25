import 'package:flutter/material.dart';

import '../services/shell_core_client.dart';
import 'shared.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key, required this.client});

  final ShellCoreClient client;

  @override
  Widget build(BuildContext context) {
    final settings = client.getSnapshot().settings;
    return ShellPage(
      title: 'Settings',
      children: [
        const SectionList(title: 'Search Filters', rows: [
          'search',
          '@modified',
          '@dangerous',
          '@authority',
          '@runtime',
          '@adapter',
          '@hidden',
        ]),
        DataTable(
          columns: const [
            DataColumn(label: Text('Setting')),
            DataColumn(label: Text('Group')),
            DataColumn(label: Text('Default')),
            DataColumn(label: Text('Current')),
            DataColumn(label: Text('Effective')),
            DataColumn(label: Text('Source')),
            DataColumn(label: Text('Flags')),
          ],
          rows: [
            for (final setting in settings)
              DataRow(cells: [
                DataCell(Text(setting.key)),
                DataCell(Text(setting.group)),
                DataCell(Text(setting.defaultValue)),
                DataCell(Text(setting.currentValue)),
                DataCell(Text(setting.effectiveValue)),
                DataCell(Text(setting.source)),
                DataCell(Text([
                  if (setting.modified) 'modified',
                  if (setting.dangerous) 'dangerous',
                  if (setting.authorityRelated) 'authority',
                ].join(', '))),
              ]),
          ],
        ),
        const SectionList(title: 'Reset / Export', rows: [
          'reset one setting through Shell Core',
          'reset section through Shell Core',
          'export JSON/YAML projection',
          'show permission and runtime impact before applying changes',
        ]),
        const SectionList(title: 'Command Palette', rows: [
          'Open Setup Doctor',
          'Re-run validation',
          'Show authority map',
          'Export evidence bundle',
          'Revoke runtime trust',
          'Quarantine adapter',
          'Verify audit chain',
          'Create issue report',
          'mutating commands require Shell Core authorization',
        ]),
      ],
    );
  }
}
