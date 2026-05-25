import 'package:flutter/material.dart';

import '../services/shell_core_client.dart';
import 'shared.dart';

class RecoveryCenter extends StatelessWidget {
  const RecoveryCenter({super.key, required this.client});

  final ShellCoreClient client;

  @override
  Widget build(BuildContext context) {
    final snapshot = client.getSnapshot();
    final recoveries = snapshot.recoveryActions;
    return ShellPage(
      title: 'Recovery Playbook',
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columns: const [
              DataColumn(label: Text('Item')),
              DataColumn(label: Text('Severity')),
              DataColumn(label: Text('Classification')),
              DataColumn(label: Text('Safe for Phase B')),
              DataColumn(label: Text('Blocks Product Release')),
              DataColumn(label: Text('Required Action')),
            ],
            rows: [
              for (final item in snapshot.recoveryPlaybook)
                DataRow(cells: [
                  DataCell(Text(item.item)),
                  DataCell(Text(item.severity)),
                  DataCell(Text(item.classification)),
                  DataCell(Text(item.safeToIgnoreForPhaseB ? 'true' : 'false')),
                  DataCell(
                      Text(item.blocksCompletedProductRelease ? 'yes' : 'no')),
                  DataCell(Text(item.requiredAction)),
                ]),
            ],
          ),
        ),
        for (final recovery in recoveries)
          BorderedPanel(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.health_and_safety_outlined),
                  title: Text(recovery.recoveryId),
                  subtitle: Text(recovery.message),
                  trailing:
                      Text(recovery.safeToRetry ? 'retryable' : 'blocked'),
                ),
                SectionList(title: 'Playbook', rows: [
                  'severity: ${recovery.severity}',
                  'can_auto_fix: false',
                  'pre_check: verify Shell Core authorization',
                  'action_steps: copy command / open logs / retry through approved capability',
                  'post_check: rerun validation or Setup Doctor check',
                  'rollback: use related audit event and recovery mapping',
                ]),
              ],
            ),
          ),
      ],
    );
  }
}
