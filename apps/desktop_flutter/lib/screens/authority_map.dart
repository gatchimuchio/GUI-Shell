import 'package:flutter/material.dart';

import '../services/shell_core_client.dart';
import 'shared.dart';

class AuthorityMap extends StatelessWidget {
  const AuthorityMap({super.key, required this.client});

  final ShellCoreClient client;

  @override
  Widget build(BuildContext context) {
    final snapshot = client.getSnapshot();
    return ShellPage(
      title: 'Authority Map',
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columns: const [
              DataColumn(label: Text('Runtime')),
              DataColumn(label: Text('Capability')),
              DataColumn(label: Text('Permission')),
              DataColumn(label: Text('Approval')),
              DataColumn(label: Text('Audit')),
              DataColumn(label: Text('Recovery')),
              DataColumn(label: Text('Risk')),
            ],
            rows: [
              for (final item in snapshot.authorityMap)
                DataRow(cells: [
                  DataCell(Text(item.runtimeId)),
                  DataCell(Text(item.capabilityId)),
                  DataCell(Text(item.permissionId)),
                  DataCell(Text(item.approvalId)),
                  DataCell(Text(item.auditEventId)),
                  DataCell(Text(item.recoveryId)),
                  DataCell(Text(item.dangerous
                      ? 'dangerous'
                      : (item.warning.isEmpty ? 'mapped' : item.warning))),
                ]),
            ],
          ),
        ),
        const SectionList(
          title: 'Display Boundary',
          rows: [
            'Authority decisions remain in Shell Core.',
            'Non-authority source attempts are warnings until Shell Core audit and recovery mappings authorize action.',
          ],
        ),
        SectionList(
          title: 'Export Preview',
          rows: [
            for (final item in snapshot.authorityMap)
              '${item.runtimeId} -> ${item.capabilityId} -> ${item.permissionId} -> ${item.approvalId} -> ${item.auditEventId} -> ${item.recoveryId}',
          ],
        ),
      ],
    );
  }
}
