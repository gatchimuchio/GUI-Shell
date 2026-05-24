import 'package:flutter/material.dart';

import '../services/shell_core_client.dart';
import 'shared.dart';

class AuditViewer extends StatelessWidget {
  const AuditViewer({super.key, required this.client});

  final ShellCoreClient client;

  @override
  Widget build(BuildContext context) {
    final auditEvents = client.getSnapshot().auditEvents;
    return ShellPage(
      title: 'Audit Viewer',
      children: [
        DataTable(
          columns: const [
            DataColumn(label: Text('Event')),
            DataColumn(label: Text('Action')),
            DataColumn(label: Text('Result')),
            DataColumn(label: Text('Payload Hash')),
            DataColumn(label: Text('Previous')),
          ],
          rows: [
            for (final event in auditEvents)
              DataRow(cells: [
                DataCell(Text(event.eventId)),
                DataCell(Text(event.action)),
                DataCell(Text(event.result)),
                DataCell(Text(event.payloadHash)),
                DataCell(Text(event.previousEventHash ?? 'root')),
              ]),
          ],
        ),
      ],
    );
  }
}
