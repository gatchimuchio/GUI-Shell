import 'package:flutter/material.dart';

import '../services/shell_core_client.dart';
import 'shared.dart';

class RuntimeCenter extends StatelessWidget {
  const RuntimeCenter({super.key, required this.client});

  final ShellCoreClient client;

  @override
  Widget build(BuildContext context) {
    final snapshot = client.getSnapshot();
    return ShellPage(
      title: 'Runtime Center',
      children: [
        DataTable(
          columns: const [
            DataColumn(label: Text('Runtime')),
            DataColumn(label: Text('Status')),
            DataColumn(label: Text('Adapter')),
            DataColumn(label: Text('Diagnostics')),
          ],
          rows: [
            for (final runtime in snapshot.runtimes)
              DataRow(cells: [
                DataCell(Text(runtime.name)),
                DataCell(Text(runtime.status)),
                DataCell(Text(runtime.adapterId)),
                DataCell(Text(runtime.diagnosticSummary)),
              ]),
          ],
        ),
      ],
    );
  }
}
