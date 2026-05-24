import 'package:flutter/material.dart';

import '../services/shell_core_client.dart';
import 'shared.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key, required this.client});

  final ShellCoreClient client;

  @override
  Widget build(BuildContext context) {
    final snapshot = client.getSnapshot();
    return ShellPage(
      title: 'Dashboard',
      children: [
        MetricRow(items: [
          MetricItem(label: 'Runtimes', value: '${snapshot.runtimes.length}'),
          MetricItem(label: 'Pending', value: '${snapshot.pendingApprovals.length}'),
          MetricItem(label: 'Audit', value: '${snapshot.auditEvents.length}'),
          MetricItem(label: 'Recovery', value: '${snapshot.recoveryActions.length}'),
        ]),
        SectionList(
          title: 'Runtime Status',
          rows: [for (final runtime in snapshot.runtimes) '${runtime.name}  ${runtime.status}  ${runtime.adapterId}'],
        ),
        SectionList(
          title: 'Invariant Status',
          rows: [for (final entry in snapshot.invariantFlags.entries) '${entry.key}: ${entry.value ? 'violation' : 'ok'}'],
        ),
      ],
    );
  }
}
