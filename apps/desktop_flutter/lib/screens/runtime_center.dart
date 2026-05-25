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
        for (final adapter in snapshot.adapterCatalog)
          SectionList(
            title: 'Adapter Catalog: ${adapter.adapterId}',
            rows: [
              'runtime: ${adapter.runtimeId}',
              'publisher: ${adapter.publisher}',
              'version: ${adapter.version}',
              'signature: ${adapter.signature}',
              'hash: ${adapter.hash}',
              'trust: ${adapter.trustStatus}',
              'requested: ${adapter.requestedCapabilities.join(', ')}',
              'granted: ${adapter.grantedCapabilities.join(', ')}',
              'denied: ${adapter.deniedCapabilities.join(', ')}',
              'risks: ${adapter.knownRisks.join(', ')}',
            ],
          ),
        for (final diff in snapshot.permissionDiffs)
          SectionList(
            title: 'Permission Diff: ${diff.subject}',
            rows: [
              for (final item in diff.added) '+ $item',
              for (final item in diff.removed) '- $item',
              for (final item in diff.changed) '~ $item',
              for (final item in diff.dangerous) '! $item',
            ],
          ),
      ],
    );
  }
}
