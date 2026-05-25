import 'package:flutter/material.dart';

import '../services/shell_core_client.dart';
import 'shared.dart';

class RecoveryCenter extends StatelessWidget {
  const RecoveryCenter({super.key, required this.client});

  final ShellCoreClient client;

  @override
  Widget build(BuildContext context) {
    final recoveries = client.getSnapshot().recoveryActions;
    return ShellPage(
      title: 'Recovery Center',
      children: [
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
