import 'package:flutter/material.dart';

import '../services/shell_core_client.dart';
import 'shared.dart';

class SetupDoctor extends StatelessWidget {
  const SetupDoctor({super.key, required this.client});

  final ShellCoreClient client;

  @override
  Widget build(BuildContext context) {
    final snapshot = client.getSnapshot();
    return ShellPage(
      title: 'Setup Doctor',
      children: [
        SectionList(
          title: 'Environment',
          rows: const ['Python: checked by schema tools', 'Rust: not detected in current environment', 'Flutter: not detected in current environment'],
        ),
        SectionList(
          title: 'Runtime Connection',
          rows: [for (final runtime in snapshot.runtimes) '${runtime.runtimeId}: ${runtime.status}'],
        ),
        SectionList(
          title: 'Recovery Instructions',
          rows: [for (final recovery in snapshot.recoveryActions) recovery.message],
        ),
      ],
    );
  }
}
