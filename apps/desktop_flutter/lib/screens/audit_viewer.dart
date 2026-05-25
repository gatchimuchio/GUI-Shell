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
        const Wrap(spacing: 8, runSpacing: 8, children: [
          StatusPill(label: 'filter', value: 'runtime'),
          StatusPill(label: 'filter', value: 'adapter'),
          StatusPill(label: 'filter', value: 'approval'),
          StatusPill(label: 'filter', value: 'permission'),
          StatusPill(label: 'filter', value: 'setup_doctor'),
          StatusPill(label: 'filter', value: 'normalization'),
          StatusPill(label: 'filter', value: 'installer'),
          StatusPill(label: 'filter', value: 'error/warning/blocked'),
        ]),
        SectionList(
          title: 'Chain Status',
          rows: [
            'audit_chain_status: ${client.getSnapshot().auditChainStatus}',
            'actions: copy event / export JSONL / verify chain / jump to related approval-runtime-adapter',
          ],
        ),
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
