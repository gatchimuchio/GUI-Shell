import '../models/generated_contracts.dart';

class ShellCoreClient {
  const ShellCoreClient._(this.snapshot);

  final ShellSnapshot snapshot;

  factory ShellCoreClient.local() => ShellCoreClient.mock();

  factory ShellCoreClient.mock() {
    return const ShellCoreClient._(
      ShellSnapshot(
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
            projectedContent: {
              'path': 'notes/today.md',
              'content': '[redacted]'
            },
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
      ),
    );
  }

  ShellSnapshot getSnapshot() => snapshot;
}
