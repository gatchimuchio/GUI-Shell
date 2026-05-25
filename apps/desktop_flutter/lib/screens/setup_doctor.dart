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
        const SectionList(
          title: 'Authority Boundary',
          rows: [
            'installer_grants_authority=false',
            'installer_silently_approves_permissions=false'
          ],
        ),
        SectionList(
          title: 'Diagnostics',
          rows: [
            'status: ${snapshot.setupDoctorStatus}',
            for (final check in snapshot.setupDoctorChecks)
              '${check.checkId}: ${check.status} - ${check.message}${check.recoveryInstruction == null ? '' : ' / ${check.recoveryInstruction}'}',
          ],
        ),
        SectionList(
          title: 'Installed Path Evidence',
          rows: [
            for (final evidence in snapshot.evidence
                .where((item) => item.kind == 'installed-path'))
              '${evidence.evidenceId}: ${evidence.status} ${evidence.path}',
          ],
        ),
        SectionList(
          title: 'Runtime Connection',
          rows: [
            for (final runtime in snapshot.runtimes)
              '${runtime.runtimeId}: ${runtime.status}'
          ],
        ),
        SectionList(
          title: 'Recovery Instructions',
          rows: [
            for (final recovery in snapshot.recoveryActions) recovery.message
          ],
        ),
      ],
    );
  }
}
