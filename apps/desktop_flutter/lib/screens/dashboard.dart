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
          MetricItem(
              label: 'Pending', value: '${snapshot.pendingApprovals.length}'),
          MetricItem(label: 'Audit', value: '${snapshot.auditEvents.length}'),
          MetricItem(
              label: 'Blockers', value: '${snapshot.releaseBlockerCount}'),
        ]),
        SectionList(
          title: 'Trust Status',
          rows: [
            for (final trust in snapshot.trustRecords)
              '${trust.scope}: ${trust.state} (${trust.source})'
          ],
        ),
        SectionList(
          title: 'Release Blockers',
          rows: [
            for (final problem in snapshot.problems)
              '${problem.severity}: ${problem.message}'
          ],
        ),
        SectionList(
          title: 'Problems Panel',
          rows: [
            for (final problem in snapshot.problems)
              '${problem.category}: ${problem.message} -> ${problem.recoveryId}'
          ],
        ),
        SectionList(
          title: 'Evidence Center',
          rows: [
            for (final evidence in snapshot.evidence)
              '${evidence.evidenceId}: ${evidence.status} ${evidence.path}'
          ],
        ),
        SectionList(
          title: 'Recent Audit Events',
          rows: [
            for (final event in snapshot.auditEvents)
              '${event.eventId}: ${event.action} ${event.result}'
          ],
        ),
        SectionList(
          title: 'Runtime Status',
          rows: [
            for (final runtime in snapshot.runtimes)
              '${runtime.name}  ${runtime.status}  ${runtime.adapterId}'
          ],
        ),
        SectionList(
          title: 'Invariant Status',
          rows: [
            for (final entry in snapshot.invariantFlags.entries)
              '${entry.key}: ${entry.value ? 'violation' : 'ok'}'
          ],
        ),
      ],
    );
  }
}
