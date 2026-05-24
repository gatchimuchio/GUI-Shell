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
            child: ListTile(
              leading: const Icon(Icons.health_and_safety_outlined),
              title: Text(recovery.recoveryId),
              subtitle: Text(recovery.message),
              trailing: Text(recovery.safeToRetry ? 'retryable' : 'blocked'),
            ),
          ),
      ],
    );
  }
}
