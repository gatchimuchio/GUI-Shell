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
}

class ShellSnapshot {
  const ShellSnapshot({
    required this.runtimes,
    required this.permissions,
    required this.pendingApprovals,
    required this.auditEvents,
    required this.recoveryActions,
    required this.invariantFlags,
  });

  final List<RuntimeRecord> runtimes;
  final List<PermissionRecord> permissions;
  final List<ApprovalRecord> pendingApprovals;
  final List<AuditRecord> auditEvents;
  final List<RecoveryRecord> recoveryActions;
  final Map<String, bool> invariantFlags;
}
