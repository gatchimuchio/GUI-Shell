import 'package:flutter/material.dart';

import '../services/shell_core_client.dart';
import 'shared.dart';

class PermissionCenter extends StatelessWidget {
  const PermissionCenter({super.key, required this.client});

  final ShellCoreClient client;

  @override
  Widget build(BuildContext context) {
    final snapshot = client.getSnapshot();
    return ShellPage(
      title: 'Permission Center',
      children: [
        DataTable(
          columns: const [
            DataColumn(label: Text('Permission')),
            DataColumn(label: Text('Capability')),
            DataColumn(label: Text('Decision')),
            DataColumn(label: Text('Source')),
            DataColumn(label: Text('Expiry')),
          ],
          rows: [
            for (final permission in snapshot.permissions)
              DataRow(cells: [
                DataCell(Text(permission.permissionId)),
                DataCell(Text(permission.capabilityId)),
                DataCell(Text(permission.decision)),
                DataCell(Text(permission.source)),
                DataCell(Text(permission.expiresAt ?? 'none')),
              ]),
          ],
        ),
      ],
    );
  }
}
