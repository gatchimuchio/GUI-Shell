import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/generated_contracts.dart';
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
        SnapshotInfoPanel(snapshot: snapshot),
        _EvidenceBundleExportPanel(snapshot: snapshot),
        _SnapshotExchangePanel(snapshot: snapshot),
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
        if (snapshot.evidence.isEmpty)
          const EmptyStatePanel(
            title: 'No evidence yet',
            meaning: 'The current snapshot has no evidence records to display.',
            phaseBBlocked: false,
            nextAction:
                'Run the standard validation commands when evidence state matters.',
          )
        else
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

class _EvidenceBundleExportPanel extends StatelessWidget {
  const _EvidenceBundleExportPanel({required this.snapshot});

  final ShellSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final summaryText = _validationSummaryText(snapshot);
    return BorderedPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Evidence Bundle Export',
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          const Text(
            'Display-only export helpers. These copy existing paths, summaries, or commands; they do not collect release evidence.',
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              OutlinedButton.icon(
                onPressed: () => Clipboard.setData(
                  const ClipboardData(
                    text: 'python3 tooling/evidence_bundle.py --check',
                  ),
                ),
                icon: const Icon(Icons.copy),
                label: const Text('Copy Check Command'),
              ),
              OutlinedButton.icon(
                onPressed: () =>
                    Clipboard.setData(ClipboardData(text: summaryText)),
                icon: const Icon(Icons.summarize_outlined),
                label: const Text('Copy Validation Summary'),
              ),
              OutlinedButton.icon(
                onPressed: () => Clipboard.setData(
                  const ClipboardData(text: 'release_evidence'),
                ),
                icon: const Icon(Icons.folder_copy_outlined),
                label: const Text('Copy Evidence Folder'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(summaryText),
        ],
      ),
    );
  }
}

class _SnapshotExchangePanel extends StatelessWidget {
  const _SnapshotExchangePanel({required this.snapshot});

  final ShellSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return BorderedPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Snapshot Import / Export',
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          const Text(
            'Snapshot import is preview-only in Flutter. Applying imported state remains a Shell Core responsibility.',
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              OutlinedButton.icon(
                onPressed: () => Clipboard.setData(
                  ClipboardData(text: _snapshotExportJson(snapshot)),
                ),
                icon: const Icon(Icons.ios_share_outlined),
                label: const Text('Copy Snapshot JSON'),
              ),
              OutlinedButton.icon(
                onPressed: () => Clipboard.setData(
                  ClipboardData(text: snapshot.snapshotPath),
                ),
                icon: const Icon(Icons.folder_copy_outlined),
                label: const Text('Copy Snapshot Path'),
              ),
              OutlinedButton.icon(
                onPressed: () => showDialog<void>(
                  context: context,
                  builder: (context) =>
                      _SnapshotImportPreviewDialog(current: snapshot),
                ),
                icon: const Icon(Icons.compare_arrows_outlined),
                label: const Text('Preview Import / Compare'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SnapshotImportPreviewDialog extends StatefulWidget {
  const _SnapshotImportPreviewDialog({required this.current});

  final ShellSnapshot current;

  @override
  State<_SnapshotImportPreviewDialog> createState() =>
      _SnapshotImportPreviewDialogState();
}

class _SnapshotImportPreviewDialogState
    extends State<_SnapshotImportPreviewDialog> {
  final TextEditingController _controller = TextEditingController();
  String _preview =
      'Paste snapshot JSON to preview source, release state, and counts.';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 760, maxHeight: 680),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text('Preview Snapshot Import',
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              TextField(
                controller: _controller,
                maxLines: 8,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Snapshot JSON',
                ),
                onChanged: _updatePreview,
              ),
              const SizedBox(height: 12),
              Expanded(
                child: SingleChildScrollView(
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(_preview),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Close'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _updatePreview(String value) {
    if (value.trim().isEmpty) {
      setState(() {
        _preview =
            'Paste snapshot JSON to preview source, release state, and counts.';
      });
      return;
    }
    try {
      final json = jsonDecode(value) as Map<String, Object?>;
      final imported = ShellSnapshot.fromJson(json);
      setState(() {
        _preview = [
          'Preview only: no imported data is applied.',
          'current source: ${widget.current.snapshotSource}',
          'import source: ${imported.snapshotSource}',
          'current release: ${widget.current.operationStatus.releaseState}',
          'import release: ${imported.operationStatus.releaseState}',
          'current problems: ${widget.current.problems.length}',
          'import problems: ${imported.problems.length}',
          'current recovery rows: ${widget.current.recoveryPlaybook.length}',
          'import recovery rows: ${imported.recoveryPlaybook.length}',
          'current evidence rows: ${widget.current.evidence.length}',
          'import evidence rows: ${imported.evidence.length}',
          'Phase B blocked by import preview: ${imported.problems.any((problem) => problem.blocksOwnerUse) ? 'yes' : 'no'}',
        ].join('\n');
      });
    } on Object catch (error) {
      setState(() {
        _preview = 'Invalid snapshot JSON: $error';
      });
    }
  }
}

String _validationSummaryText(ShellSnapshot snapshot) {
  final summary = snapshot.evidenceSummary;
  return [
    'schema_check=${summary.schemaCheck}',
    'conformance_checks=${summary.conformanceCheckCount}',
    'release_smoke=${summary.releaseSmoke}',
    'release_gate_check=${summary.releaseGateCheck}',
    'evidence_bundle=${summary.evidenceBundle}',
    'validate_all=${summary.validateAll}',
    'strict_windows_release=${summary.strictWindowsRelease}',
    'release_state=${snapshot.operationStatus.releaseState}',
  ].join('\n');
}

String _snapshotExportJson(ShellSnapshot snapshot) {
  final json = {
    'snapshot_source': snapshot.snapshotSource,
    'snapshot_path': snapshot.snapshotPath,
    'snapshot_generated_at': snapshot.snapshotGeneratedAt,
    'snapshot_freshness': snapshot.snapshotFreshness,
    'operation_status': {
      'runtime_status': snapshot.operationStatus.runtimeStatus,
      'invariant_status': snapshot.operationStatus.invariantStatus,
      'trust_status': snapshot.operationStatus.trustStatus,
      'pending_approvals_count': snapshot.operationStatus.pendingApprovalsCount,
      'audit_chain_status': snapshot.operationStatus.auditChainStatus,
      'problems_count': snapshot.operationStatus.problemsCount,
      'release_state': snapshot.operationStatus.releaseState,
    },
    'phase_status': {
      'phase_a_status': snapshot.phaseStatus.phaseAStatus,
      'phase_b_status': snapshot.phaseStatus.phaseBStatus,
      'phase_c_status': snapshot.phaseStatus.phaseCStatus,
      'phase_d_status': snapshot.phaseStatus.phaseDStatus,
      'phase_e_status': snapshot.phaseStatus.phaseEStatus,
      'phase_f_status': snapshot.phaseStatus.phaseFStatus,
      'completed_product_release_claimed':
          snapshot.phaseStatus.completedProductReleaseClaimed,
    },
    'counts': {
      'runtimes': snapshot.runtimes.length,
      'problems': snapshot.problems.length,
      'evidence': snapshot.evidence.length,
      'recovery_playbook': snapshot.recoveryPlaybook.length,
      'pending_approvals': snapshot.pendingApprovals.length,
    },
    'release_ready_claimed': false,
  };
  return const JsonEncoder.withIndent('  ').convert(json);
}
