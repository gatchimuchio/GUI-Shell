import 'dart:convert';
import 'dart:io';

import '../models/generated_contracts.dart';

class ShellCoreClient {
  const ShellCoreClient._(this.snapshot, this.mode);

  final ShellSnapshot snapshot;
  final String mode;

  factory ShellCoreClient.local({String? snapshotPath}) {
    final paths = snapshotPath == null
        ? _candidateSnapshotPaths()
        : <String>[snapshotPath];
    for (final resolvedPath in paths) {
      final file = File(resolvedPath);
      if (!file.existsSync()) {
        continue;
      }
      try {
        final json =
            jsonDecode(file.readAsStringSync()) as Map<String, Object?>;
        final snapshot = ShellSnapshot.fromJson(json).copyWith(
          snapshotSource: json['snapshot_source'] as String? ?? 'local',
          snapshotPath: resolvedPath,
          snapshotFreshness: json['snapshot_freshness'] as String? ??
              file.lastModifiedSync().toIso8601String(),
        );
        return ShellCoreClient._(snapshot, 'local');
      } on Object {
        return ShellCoreClient._(
          _snapshotWithLocalIssue(
            problemId: 'local-snapshot-parse-failed',
            item: 'local snapshot parse failed',
            classification: 'required_for_v1',
            severity: 'warning',
            message: 'Local owner-operation snapshot could not be parsed.',
            target: resolvedPath,
            requiredAction:
                'Regenerate the snapshot with python3 tooling/shell_snapshot.py --write .gui_shell/shell_snapshot.json.',
            source: 'fallback',
            freshness: 'parse failed',
          ),
          'local',
        );
      }
    }
    return ShellCoreClient._(
      _snapshotWithLocalIssue(
        problemId: 'local-snapshot-missing',
        item: 'local snapshot missing',
        classification: 'known_limitation',
        severity: 'info',
        message: 'Local owner-operation snapshot file is missing.',
        target: paths.first,
        requiredAction:
            'Generate .gui_shell/shell_snapshot.json for live local owner state.',
        source: 'fallback',
        freshness: 'missing',
      ),
      'local',
    );
  }

  factory ShellCoreClient.mock() {
    return const ShellCoreClient._(
      _mockSnapshot,
      'mock',
    );
  }

  ShellSnapshot getSnapshot() => snapshot;
}

List<String> _candidateSnapshotPaths() {
  final explicit = Platform.environment['GUI_SHELL_SNAPSHOT_JSON'];
  if (explicit != null && explicit.isNotEmpty) {
    return [explicit];
  }
  final paths = <String>[];
  if (Platform.isWindows) {
    final localAppData = Platform.environment['LOCALAPPDATA'];
    if (localAppData != null && localAppData.isNotEmpty) {
      paths.add('$localAppData\\GUI-Shell\\shell_snapshot.json');
    }
  }
  paths.add('.gui_shell/shell_snapshot.json');
  paths.add('.gui-shell/shell_snapshot.json');
  return paths;
}

ShellSnapshot _snapshotWithLocalIssue({
  required String problemId,
  required String item,
  required String classification,
  required String severity,
  required String message,
  required String target,
  required String requiredAction,
  required String source,
  required String freshness,
}) {
  final problem = ProblemRecord(
    problemId: problemId,
    severity: severity,
    category: 'local_snapshot',
    message: message,
    target: target,
    recoveryId: 'recover-local-snapshot',
    item: item,
    classification: classification,
    reason: message,
    requiredAction: requiredAction,
    blocksRelease: false,
  );
  final problems = [problem, ..._localFallbackSnapshot.problems];
  return _localFallbackSnapshot.copyWith(
    problems: problems,
    operationStatus: _localFallbackSnapshot.operationStatus.copyWith(
      problemsCount: problems.length,
      releaseState: 'not claimed',
    ),
    snapshotSource: source,
    snapshotPath: target,
    snapshotFreshness: freshness,
  );
}

const _mockSnapshot = ShellSnapshot(
  phaseStatus: PhaseStatusRecord(
    phaseAStatus: 'complete',
    phaseBStatus: 'complete',
    phaseCStatus: 'next',
    phaseDStatus: 'later',
    phaseEStatus: 'later',
    phaseFStatus: 'later',
    completedProductReleaseClaimed: false,
  ),
  operationStatus: OperationStatusRecord(
    runtimeStatus: 'ready',
    invariantStatus: 'ok',
    trustStatus: 'restricted',
    pendingApprovalsCount: 1,
    auditChainStatus: 'verified',
    problemsCount: 6,
    releaseState: 'not claimed',
  ),
  runtimes: [
    RuntimeRecord(
      runtimeId: 'blue_tanuki',
      name: 'BLUE-TANUKI',
      status: 'ready',
      adapterId: 'blue_tanuki_reference',
      diagnosticSummary: 'mock adapter contract available',
    ),
  ],
  agentSessions: [
    AgentSessionRecord(
      sessionId: 'agent-session-1',
      workspace: '/workspace/project',
      task: 'Update documentation',
      changedFiles: ['README.md', 'docs/STRATEGY.md'],
      toolCalls: ['shell.command', 'git.diff'],
      shellCommands: [
        'python3 tooling/conformance_tests/run_conformance_skeleton.py'
      ],
      testStatus: 'conformance passed',
      diffSummary: '2 files changed',
      pendingApprovalCount: 1,
      rollbackCandidate: 'rollback-1',
      auditEventId: 'audit-1',
    ),
  ],
  permissions: [
    PermissionRecord(
      permissionId: 'permission.fs.write.workspace',
      capabilityId: 'filesystem.write',
      decision: 'ask',
      source: 'policy',
    ),
  ],
  pendingApprovals: [
    ApprovalRecord(
      approvalId: 'approval-1',
      operation: 'filesystem.write',
      status: 'pending',
      contentVisibility: 'redacted',
      projectedContent: {'path': 'notes/today.md', 'content': '[redacted]'},
      editableFields: ['path'],
      protectedFields: [
        'runtime_id',
        'permission_id',
        'payload_hash',
        'authority_context'
      ],
    ),
  ],
  auditEvents: [
    AuditRecord(
      eventId: 'audit-1',
      action: 'approval.requested',
      result: 'success',
      payloadHash:
          'sha256:2222222222222222222222222222222222222222222222222222222222222222',
    ),
  ],
  recoveryActions: [
    RecoveryRecord(
      recoveryId: 'recover-1',
      severity: 'warning',
      message: 'Permission is required before this action can run.',
      safeToRetry: true,
    ),
  ],
  invariantFlags: {
    'flutter_imported_by_shell_core': false,
    'blue_tanuki_imported_by_shell_core': false,
    'adapter_metadata_can_escalate_authority': false,
    'memory_cache_previous_state_can_grant_authority': false,
    'full_payload_projected_without_full_visibility': false,
    'installer_setup_state_can_grant_authority': false,
    'mobile_device_state_can_grant_authority': false,
  },
  setupDoctorStatus: 'warning',
  installerGrantsAuthority: false,
  installerSilentlyApprovesPermissions: false,
  setupDoctorChecks: [
    SetupDoctorCheckRecord(
      checkId: 'host.os',
      status: 'pass',
      message: 'Host OS detected',
      recoveryInstruction: null,
      grantsAuthority: false,
    ),
    SetupDoctorCheckRecord(
      checkId: 'filesystem.permission',
      status: 'pass',
      message: 'Audit storage path writable',
      recoveryInstruction: null,
      grantsAuthority: false,
    ),
    SetupDoctorCheckRecord(
      checkId: 'network.public_bind',
      status: 'warning',
      message: 'Public bind requires explicit operator review',
      recoveryInstruction:
          'Keep runtimes on localhost unless permission and approval explicitly allow public bind.',
      grantsAuthority: false,
    ),
  ],
  trustRecords: [
    TrustRecord(
      scope: 'workspace_trust',
      state: 'restricted',
      source: 'local policy',
      expiresAt: null,
      blockedOperations: ['process.spawn', 'network.public_bind'],
    ),
    TrustRecord(
      scope: 'runtime_trust',
      state: 'trusted',
      source: 'signed manifest',
      expiresAt: null,
      blockedOperations: [],
    ),
    TrustRecord(
      scope: 'adapter_trust',
      state: 'inherited',
      source: 'runtime_trust',
      expiresAt: null,
      blockedOperations: [],
    ),
    TrustRecord(
      scope: 'installer_trust',
      state: 'unknown',
      source: 'installed-path evidence missing',
      expiresAt: null,
      blockedOperations: ['release_ready_claim'],
    ),
  ],
  authorityMap: [
    AuthorityMapRecord(
      runtimeId: 'blue_tanuki',
      capabilityId: 'filesystem.write',
      permissionId: 'permission.fs.write.workspace',
      approvalId: 'approval-1',
      auditEventId: 'audit-1',
      recoveryId: 'recover-1',
      dangerous: false,
      warning: 'approval pending',
    ),
  ],
  adapterCatalog: [
    AdapterCatalogRecord(
      adapterId: 'blue_tanuki_reference',
      runtimeId: 'blue_tanuki',
      publisher: 'GUI-Shell reference',
      version: '0.1.0',
      signature: 'development',
      hash: 'sha256:pending',
      requestedCapabilities: ['filesystem.write'],
      grantedCapabilities: [],
      deniedCapabilities: ['network.public_bind'],
      trustStatus: 'inherited',
      lastVerified: 'development smoke',
      updateAvailable: false,
      knownRisks: ['reference adapter only'],
    ),
  ],
  permissionDiffs: [
    PermissionDiffRecord(
      subject: 'blue_tanuki_reference',
      added: ['filesystem.write'],
      removed: [],
      changed: ['content_visibility: full -> redacted'],
      dangerous: [],
    ),
  ],
  problems: [
    ProblemRecord(
      problemId: 'windows-installed-evidence-missing',
      severity: 'blocked',
      category: 'missing_evidence',
      message: 'Windows installed-path evidence is missing.',
      target: 'release_evidence/windows_installed_smoke.json',
      recoveryId: 'recover-windows-evidence',
      item: 'measured Windows installed-path first-run evidence missing',
      classification: 'release_blocker',
      reason: 'Measured installed-path first-run evidence is not recorded.',
      requiredAction:
          'Run hardened Windows installed smoke collection on native Windows.',
      blocksRelease: true,
    ),
    ProblemRecord(
      problemId: 'setup-doctor-installed-evidence-missing',
      severity: 'blocked',
      category: 'missing_evidence',
      message: 'Non-synthetic installed-path Setup Doctor evidence is missing.',
      target: 'release_evidence/windows_installed_smoke.json',
      recoveryId: 'recover-setup-doctor-evidence',
      item: 'non-synthetic installed-path Setup Doctor evidence missing',
      classification: 'release_blocker',
      reason: 'Setup Doctor has not been proven from the installed app path.',
      requiredAction:
          'Run Setup Doctor from the installed Windows app path and record required checks.',
      blocksRelease: true,
    ),
    ProblemRecord(
      problemId: 'owner-go-missing',
      severity: 'blocked',
      category: 'release_gate',
      message: 'Owner GO missing.',
      target: 'release checklist',
      recoveryId: 'recover-owner-go',
      item: 'owner GO missing',
      classification: 'release_blocker',
      reason: 'Completed product release requires explicit owner approval.',
      requiredAction: 'Record owner GO after release blockers are cleared.',
      blocksRelease: true,
    ),
    ProblemRecord(
      problemId: 'macos-unverified',
      severity: 'info',
      category: 'scope',
      message: 'macOS remains unverified.',
      target: 'desktop platform matrix',
      recoveryId: 'recover-macos-validation',
      item: 'macOS unverified',
      classification: 'known_limitation',
      reason: 'No macOS validation environment is available.',
      requiredAction: 'Validate on macOS before claiming macOS support.',
      blocksRelease: false,
    ),
    ProblemRecord(
      problemId: 'mobile-post-v1',
      severity: 'info',
      category: 'scope',
      message: 'Mobile full release is post-v1 scope.',
      target: 'mobile status',
      recoveryId: 'recover-mobile-scope',
      item: 'mobile post-v1 scope',
      classification: 'post_v1_scope',
      reason: 'v1.0 is Windows-first desktop unless owner changes scope.',
      requiredAction: 'Defer mobile release work.',
      blocksRelease: false,
    ),
    ProblemRecord(
      problemId: 'paid-qc-later',
      severity: 'info',
      category: 'scope',
      message: 'Paid/product QC is a later phase.',
      target: 'phase strategy',
      recoveryId: 'recover-paid-qc',
      item: 'paid/product QC later',
      classification: 'post_v1_scope',
      reason: 'Phase B is owner-use hardening, not paid/product QC.',
      requiredAction: 'Defer paid/product QC until Phase F.',
      blocksRelease: false,
    ),
  ],
  evidence: [
    EvidenceRecord(
      evidenceId: 'windows-installed-smoke',
      kind: 'installed-path',
      status: 'missing',
      path: 'release_evidence/windows_installed_smoke.json',
      hash: '',
      exportable: false,
    ),
    EvidenceRecord(
      evidenceId: 'development-validation',
      kind: 'validation',
      status: 'passed',
      path: 'tooling/validate_all.py',
      hash: '',
      exportable: true,
    ),
  ],
  settings: [
    SettingRecord(
      key: 'content_visibility.default',
      group: 'authority',
      defaultValue: 'redacted',
      currentValue: 'redacted',
      effectiveValue: 'redacted',
      source: 'Shell Core policy',
      modified: false,
      dangerous: false,
      authorityRelated: true,
    ),
    SettingRecord(
      key: 'network.public_bind',
      group: 'runtime',
      defaultValue: 'blocked',
      currentValue: 'blocked',
      effectiveValue: 'blocked',
      source: 'permission ledger',
      modified: false,
      dangerous: true,
      authorityRelated: true,
    ),
  ],
  auditChainStatus: 'verified',
  networkExposure: 'localhost only',
  releaseBlockerCount: 3,
  evidenceSummary: EvidenceSummaryRecord(
    schemaCheck: 'passed',
    conformanceCheckCount: 89,
    releaseSmoke: 'passed',
    releaseGateCheck: 'passed',
    evidenceBundle: 'passed',
    validateAll: 'passed',
    strictWindowsRelease: 'expected fail',
    missingMeasuredWindowsEvidence: true,
    missingSetupDoctorEvidence: true,
    ownerGo: 'missing',
  ),
  recoveryPlaybook: [
    RecoveryPlaybookRecord(
      item: 'measured Windows installed-path evidence missing',
      severity: 'release',
      classification: 'release_blocker',
      safeToIgnoreForPhaseB: true,
      requiredAction: 'Run hardened Windows installed smoke on native Windows.',
      blocksCompletedProductRelease: true,
    ),
    RecoveryPlaybookRecord(
      item: 'non-synthetic installed-path Setup Doctor evidence missing',
      severity: 'release',
      classification: 'release_blocker',
      safeToIgnoreForPhaseB: true,
      requiredAction:
          'Run installed-path Setup Doctor and record non-synthetic checks.',
      blocksCompletedProductRelease: true,
    ),
    RecoveryPlaybookRecord(
      item: 'owner GO missing',
      severity: 'release',
      classification: 'release_blocker',
      safeToIgnoreForPhaseB: true,
      requiredAction: 'Record owner GO after release blockers pass.',
      blocksCompletedProductRelease: true,
    ),
    RecoveryPlaybookRecord(
      item: 'macOS unverified',
      severity: 'scope',
      classification: 'known_limitation',
      safeToIgnoreForPhaseB: true,
      requiredAction: 'Validate on macOS before claiming macOS support.',
      blocksCompletedProductRelease: false,
    ),
    RecoveryPlaybookRecord(
      item: 'mobile full release',
      severity: 'scope',
      classification: 'post_v1_scope',
      safeToIgnoreForPhaseB: true,
      requiredAction: 'Defer mobile full release until post-v1.',
      blocksCompletedProductRelease: false,
    ),
    RecoveryPlaybookRecord(
      item: 'Phase B owner-use usability issue',
      severity: 'owner-use',
      classification: 'required_for_v1',
      safeToIgnoreForPhaseB: false,
      requiredAction:
          'Keep dashboard, status, problems, evidence, and recovery surfaces usable.',
      blocksCompletedProductRelease: false,
    ),
  ],
  snapshotSource: 'mock',
  snapshotPath: 'embedded mock',
  snapshotFreshness: 'static',
);

const _localFallbackSnapshot = ShellSnapshot(
  phaseStatus: PhaseStatusRecord(
    phaseAStatus: 'complete',
    phaseBStatus: 'complete',
    phaseCStatus: 'next',
    phaseDStatus: 'later',
    phaseEStatus: 'later',
    phaseFStatus: 'later',
    completedProductReleaseClaimed: false,
  ),
  operationStatus: OperationStatusRecord(
    runtimeStatus: 'diagnostic',
    invariantStatus: 'ok',
    trustStatus: 'unknown',
    pendingApprovalsCount: 1,
    auditChainStatus: 'unknown',
    problemsCount: 1,
    releaseState: 'not claimed',
  ),
  runtimes: [
    RuntimeRecord(
      runtimeId: 'local_shell_core',
      name: 'Local Shell Core',
      status: 'diagnostic',
      adapterId: 'local_setup_doctor',
      diagnosticSummary: 'local diagnostic snapshot fallback',
    ),
  ],
  agentSessions: [],
  permissions: [],
  pendingApprovals: [
    ApprovalRecord(
      approvalId: 'local-approval-redacted',
      operation: 'diagnostic.review',
      status: 'pending',
      contentVisibility: 'redacted',
      projectedContent: {'summary': '[redacted]'},
      editableFields: [],
      protectedFields: ['payload_hash', 'authority_context'],
    ),
  ],
  auditEvents: [],
  recoveryActions: [],
  invariantFlags: {
    'flutter_imported_by_shell_core': false,
    'blue_tanuki_imported_by_shell_core': false,
    'adapter_metadata_can_escalate_authority': false,
    'memory_cache_previous_state_can_grant_authority': false,
    'full_payload_projected_without_full_visibility': false,
    'installer_setup_state_can_grant_authority': false,
    'mobile_device_state_can_grant_authority': false,
  },
  setupDoctorStatus: 'warning',
  installerGrantsAuthority: false,
  installerSilentlyApprovesPermissions: false,
  setupDoctorChecks: [
    SetupDoctorCheckRecord(
      checkId: 'local.snapshot',
      status: 'warning',
      message: 'Local Shell Core snapshot file not found',
      recoveryInstruction:
          'Generate .gui_shell/shell_snapshot.json or set GUI_SHELL_SNAPSHOT_JSON.',
      grantsAuthority: false,
    ),
  ],
  trustRecords: [
    TrustRecord(
      scope: 'workspace_trust',
      state: 'unknown',
      source: 'local snapshot missing',
      expiresAt: null,
      blockedOperations: ['agent.execute'],
    ),
    TrustRecord(
      scope: 'installer_trust',
      state: 'unknown',
      source: 'installed-path evidence missing',
      expiresAt: null,
      blockedOperations: ['release_ready_claim'],
    ),
  ],
  authorityMap: [],
  adapterCatalog: [],
  permissionDiffs: [],
  problems: [
    ProblemRecord(
      problemId: 'local-snapshot-missing',
      severity: 'warning',
      category: 'missing_evidence',
      message: 'Local Shell Core snapshot file is missing.',
      target: '.gui_shell/shell_snapshot.json',
      recoveryId: 'recover-local-snapshot',
      item: 'fallback snapshot active',
      classification: 'known_limitation',
      reason: 'Local snapshot was not available; safe fallback is active.',
      requiredAction:
          'Generate .gui_shell/shell_snapshot.json for local owner state.',
      blocksRelease: false,
    ),
  ],
  evidence: [
    EvidenceRecord(
      evidenceId: 'local-shell-snapshot',
      kind: 'snapshot',
      status: 'missing',
      path: '.gui_shell/shell_snapshot.json',
      hash: '',
      exportable: false,
    ),
  ],
  settings: [
    SettingRecord(
      key: 'snapshot.path',
      group: 'local',
      defaultValue: '.gui_shell/shell_snapshot.json',
      currentValue: '.gui_shell/shell_snapshot.json',
      effectiveValue: '.gui_shell/shell_snapshot.json',
      source: 'GUI_SHELL_SNAPSHOT_JSON',
      modified: false,
      dangerous: false,
      authorityRelated: false,
    ),
  ],
  auditChainStatus: 'unknown',
  networkExposure: 'unknown',
  releaseBlockerCount: 1,
  evidenceSummary: EvidenceSummaryRecord(
    schemaCheck: 'passed',
    conformanceCheckCount: 89,
    releaseSmoke: 'passed',
    releaseGateCheck: 'passed',
    evidenceBundle: 'passed',
    validateAll: 'passed',
    strictWindowsRelease: 'expected fail',
    missingMeasuredWindowsEvidence: true,
    missingSetupDoctorEvidence: true,
    ownerGo: 'missing',
  ),
  recoveryPlaybook: [
    RecoveryPlaybookRecord(
      item: 'local Shell Core snapshot missing',
      severity: 'owner-use',
      classification: 'required_for_v1',
      safeToIgnoreForPhaseB: false,
      requiredAction:
          'Generate .gui_shell/shell_snapshot.json or set GUI_SHELL_SNAPSHOT_JSON.',
      blocksCompletedProductRelease: false,
    ),
    RecoveryPlaybookRecord(
      item: 'measured Windows installed-path evidence missing',
      severity: 'release',
      classification: 'release_blocker',
      safeToIgnoreForPhaseB: true,
      requiredAction: 'Run hardened Windows installed smoke on native Windows.',
      blocksCompletedProductRelease: true,
    ),
  ],
  snapshotSource: 'fallback',
  snapshotPath: '.gui_shell/shell_snapshot.json',
  snapshotFreshness: 'missing',
);
