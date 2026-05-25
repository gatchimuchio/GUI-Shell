import 'package:flutter/material.dart';

import '../services/shell_core_client.dart';
import 'shared.dart';

class TrustCenter extends StatelessWidget {
  const TrustCenter({super.key, required this.client});

  final ShellCoreClient client;

  @override
  Widget build(BuildContext context) {
    final trust = client.getSnapshot().trustRecords;
    return ShellPage(
      title: 'Trust Center',
      children: [
        DataTable(
          columns: const [
            DataColumn(label: Text('Scope')),
            DataColumn(label: Text('State')),
            DataColumn(label: Text('Source')),
            DataColumn(label: Text('Expires')),
            DataColumn(label: Text('Blocked Operations')),
          ],
          rows: [
            for (final item in trust)
              DataRow(cells: [
                DataCell(Text(item.scope)),
                DataCell(StatusPill(label: 'trust', value: item.state)),
                DataCell(Text(item.source)),
                DataCell(Text(item.expiresAt ?? 'none')),
                DataCell(Text(item.blockedOperations.join(', '))),
              ]),
          ],
        ),
        const SectionList(
          title: 'Mutation Boundary',
          rows: [
            'Trust changes require Shell Core capability, permission, approval, audit event, and recovery mapping.',
            'Restricted, untrusted, quarantined, expired, and unknown trust states restrict agent/runtime execution.',
          ],
        ),
      ],
    );
  }
}
