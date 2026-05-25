class RuntimeRecord {
  const RuntimeRecord({
    required this.runtimeId,
    required this.name,
    required this.status,
    required this.adapterId,
    required this.diagnosticSummary,
  });

  final String runtimeId;
  final String name;
  final String status;
  final String adapterId;
  final String diagnosticSummary;

  factory RuntimeRecord.fromJson(Map<String, Object?> json) {
    return RuntimeRecord(
      runtimeId: json['runtime_id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      status: json['status'] as String? ?? '',
      adapterId: json['adapter_id'] as String? ?? '',
      diagnosticSummary: json['diagnostic_summary'] as String? ?? '',
    );
  }
}

class PermissionRecord {
  const PermissionRecord({
    required this.permissionId,
    required this.capabilityId,
    required this.decision,
    required this.source,
    this.expiresAt,
  });

  final String permissionId;
  final String capabilityId;
  final String decision;
  final String source;
  final String? expiresAt;

  factory PermissionRecord.fromJson(Map<String, Object?> json) {
    return PermissionRecord(
      permissionId: json['permission_id'] as String? ?? '',
      capabilityId: json['capability_id'] as String? ?? '',
      decision: json['decision'] as String? ?? '',
      source: json['source'] as String? ?? '',
      expiresAt: json['expires_at'] as String?,
    );
  }
}

class ApprovalRecord {
  const ApprovalRecord({
    required this.approvalId,
    required this.operation,
    required this.status,
    required this.contentVisibility,
    required this.projectedContent,
    required this.editableFields,
    required this.protectedFields,
  });

  final String approvalId;
  final String operation;
  final String status;
  final String contentVisibility;
  final Map<String, Object?> projectedContent;
  final List<String> editableFields;
  final List<String> protectedFields;

  factory ApprovalRecord.fromJson(Map<String, Object?> json) {
    return ApprovalRecord(
      approvalId: json['approval_id'] as String? ?? '',
      operation: json['operation'] as String? ?? '',
      status: json['status'] as String? ?? '',
      contentVisibility: json['content_visibility'] as String? ?? 'redacted',
      projectedContent:
          Map<String, Object?>.from(json['projected_content'] as Map? ?? {}),
      editableFields: _stringList(json['editable_fields']),
      protectedFields: _stringList(json['protected_fields']),
    );
  }
}

class AuditRecord {
  const AuditRecord({
    required this.eventId,
    required this.action,
    required this.result,
    required this.payloadHash,
    this.previousEventHash,
  });

  final String eventId;
  final String action;
  final String result;
  final String payloadHash;
  final String? previousEventHash;

  factory AuditRecord.fromJson(Map<String, Object?> json) {
    return AuditRecord(
      eventId: json['event_id'] as String? ?? '',
      action: json['action'] as String? ?? '',
      result: json['result'] as String? ?? '',
      payloadHash: json['payload_hash'] as String? ?? '',
      previousEventHash: json['previous_event_hash'] as String?,
    );
  }
}

class RecoveryRecord {
  const RecoveryRecord({
    required this.recoveryId,
    required this.severity,
    required this.message,
    required this.safeToRetry,
  });

  final String recoveryId;
  final String severity;
  final String message;
  final bool safeToRetry;

  factory RecoveryRecord.fromJson(Map<String, Object?> json) {
    return RecoveryRecord(
      recoveryId: json['recovery_id'] as String? ?? '',
      severity: json['severity'] as String? ?? '',
      message: json['message'] as String? ?? '',
      safeToRetry: json['safe_to_retry'] as bool? ?? false,
    );
  }
}

class AgentSessionRecord {
  const AgentSessionRecord({
    required this.sessionId,
    required this.workspace,
    required this.task,
    required this.changedFiles,
    required this.toolCalls,
    required this.shellCommands,
    required this.testStatus,
    required this.diffSummary,
    required this.pendingApprovalCount,
    required this.rollbackCandidate,
    required this.auditEventId,
  });

  final String sessionId;
  final String workspace;
  final String task;
  final List<String> changedFiles;
  final List<String> toolCalls;
  final List<String> shellCommands;
  final String testStatus;
  final String diffSummary;
  final int pendingApprovalCount;
  final String rollbackCandidate;
  final String auditEventId;

  factory AgentSessionRecord.fromJson(Map<String, Object?> json) {
    return AgentSessionRecord(
      sessionId: json['session_id'] as String? ?? '',
      workspace: json['workspace'] as String? ?? '',
      task: json['task'] as String? ?? '',
      changedFiles: _stringList(json['changed_files']),
      toolCalls: _stringList(json['tool_calls']),
      shellCommands: _stringList(json['shell_commands']),
      testStatus: json['test_status'] as String? ?? '',
      diffSummary: json['diff_summary'] as String? ?? '',
      pendingApprovalCount: json['pending_approval_count'] as int? ?? 0,
      rollbackCandidate: json['rollback_candidate'] as String? ?? '',
      auditEventId: json['audit_event_id'] as String? ?? '',
    );
  }
}

class SetupDoctorCheckRecord {
  const SetupDoctorCheckRecord({
    required this.checkId,
    required this.status,
    required this.message,
    required this.recoveryInstruction,
    required this.grantsAuthority,
  });

  final String checkId;
  final String status;
  final String message;
  final String? recoveryInstruction;
  final bool grantsAuthority;

  factory SetupDoctorCheckRecord.fromJson(Map<String, Object?> json) {
    return SetupDoctorCheckRecord(
      checkId: json['check_id'] as String? ?? '',
      status: json['status'] as String? ?? '',
      message: json['message'] as String? ?? '',
      recoveryInstruction: json['recovery_instruction'] as String?,
      grantsAuthority: json['grants_authority'] as bool? ?? false,
    );
  }
}

class ShellSnapshot {
  const ShellSnapshot({
    required this.runtimes,
    required this.agentSessions,
    required this.permissions,
    required this.pendingApprovals,
    required this.auditEvents,
    required this.recoveryActions,
    required this.invariantFlags,
    required this.setupDoctorChecks,
    required this.setupDoctorStatus,
    required this.installerGrantsAuthority,
    required this.installerSilentlyApprovesPermissions,
  });

  final List<RuntimeRecord> runtimes;
  final List<AgentSessionRecord> agentSessions;
  final List<PermissionRecord> permissions;
  final List<ApprovalRecord> pendingApprovals;
  final List<AuditRecord> auditEvents;
  final List<RecoveryRecord> recoveryActions;
  final Map<String, bool> invariantFlags;
  final List<SetupDoctorCheckRecord> setupDoctorChecks;
  final String setupDoctorStatus;
  final bool installerGrantsAuthority;
  final bool installerSilentlyApprovesPermissions;

  factory ShellSnapshot.fromJson(Map<String, Object?> json) {
    return ShellSnapshot(
      runtimes: _records(json['runtimes'], RuntimeRecord.fromJson),
      agentSessions:
          _records(json['agent_sessions'], AgentSessionRecord.fromJson),
      permissions: _records(json['permissions'], PermissionRecord.fromJson),
      pendingApprovals:
          _records(json['pending_approvals'], ApprovalRecord.fromJson),
      auditEvents: _records(json['audit_events'], AuditRecord.fromJson),
      recoveryActions:
          _records(json['recovery_actions'], RecoveryRecord.fromJson),
      invariantFlags:
          Map<String, bool>.from(json['invariant_flags'] as Map? ?? {}),
      setupDoctorChecks: _records(
          json['setup_doctor_checks'], SetupDoctorCheckRecord.fromJson),
      setupDoctorStatus: json['setup_doctor_status'] as String? ?? 'warning',
      installerGrantsAuthority:
          json['installer_grants_authority'] as bool? ?? false,
      installerSilentlyApprovesPermissions:
          json['installer_silently_approves_permissions'] as bool? ?? false,
    );
  }
}

List<String> _stringList(Object? value) {
  return (value as List? ?? []).map((item) => item.toString()).toList();
}

List<T> _records<T>(
  Object? value,
  T Function(Map<String, Object?> json) decode,
) {
  return (value as List? ?? [])
      .whereType<Map>()
      .map((item) => decode(Map<String, Object?>.from(item)))
      .toList();
}
