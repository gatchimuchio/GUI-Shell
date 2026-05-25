import 'package:flutter/material.dart';

import '../services/shell_core_client.dart';
import 'shared.dart';

class EvidenceCenter extends StatelessWidget {
  const EvidenceCenter({super.key, required this.client});

  final ShellCoreClient client;

  @override
  Widget build(BuildContext context) {
    final snapshot = client.getSnapshot();
    final summary = snapshot.evidenceSummary;
    return ShellPage(
      title: 'Evidence Center',
      children: [
        const SectionList(title: 'Release Boundary', rows: [
          'Evidence Center is display-only in Phase B.',
          'Missing release evidence blocks completed product release, not Phase B owner-use operation.',
          'This screen does not generate release evidence.',
        ]),
        SectionList(
          title: 'Validation Summary',
          rows: [
            'schema_check: ${summary.schemaCheck}',
            'conformance_skeleton: passed, ${summary.conformanceCheckCount} checks',
            'release_smoke: ${summary.releaseSmoke}',
            'release_gate_check: ${summary.releaseGateCheck}',
            'evidence_bundle: ${summary.evidenceBundle}',
            'validate_all: ${summary.validateAll}',
            'strict_windows_release: ${summary.strictWindowsRelease}',
            'missing measured Windows evidence: ${summary.missingMeasuredWindowsEvidence ? 'release_blocker' : 'none'}',
            'missing non-synthetic Setup Doctor evidence: ${summary.missingSetupDoctorEvidence ? 'release_blocker' : 'none'}',
            'owner GO: ${summary.ownerGo}',
          ],
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columns: const [
              DataColumn(label: Text('Evidence')),
              DataColumn(label: Text('Kind')),
              DataColumn(label: Text('Status')),
              DataColumn(label: Text('Path')),
              DataColumn(label: Text('Exportable')),
            ],
            rows: [
              for (final evidence in snapshot.evidence)
                DataRow(cells: [
                  DataCell(Text(evidence.evidenceId)),
                  DataCell(Text(evidence.kind)),
                  DataCell(Text(evidence.status)),
                  DataCell(Text(evidence.path)),
                  DataCell(Text(evidence.exportable ? 'yes' : 'no')),
                ]),
            ],
          ),
        ),
      ],
    );
  }
}
