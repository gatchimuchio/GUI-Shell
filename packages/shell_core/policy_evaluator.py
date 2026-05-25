from .error_taxonomy import (
    ADAPTER_METADATA_ESCALATION_ATTEMPT,
    APPROVAL_MISSING,
    APPROVAL_NOT_VALID,
    AUDIT_MAPPING_MISSING,
    NON_AUTHORITY_SOURCE_ATTEMPT,
    PERMISSION_DENIED,
    RECOVERY_MAPPING_MISSING,
    UNKNOWN_CAPABILITY,
    UNKNOWN_PERMISSION,
    UNKNOWN_RUNTIME,
    shell_error,
)
from .permission_ledger import NON_AUTHORITY_SOURCES
from .runtime_state import RuntimeState
from .normalization import authority_keys_in, authority_values_in, strip_authority_keys


ALLOWED_PERMISSION_DECISIONS = {"allow", "approved"}


class PolicyEvaluator:
    def __init__(self, state: RuntimeState):
        self.state = state

    def evaluate(self, action: dict) -> dict:
        operation = action.get("operation", "unknown")
        errors = []

        runtime_id = action.get("runtime_id")
        if runtime_id is not None and runtime_id not in self.state.runtimes:
            errors.append(shell_error(UNKNOWN_RUNTIME, f"unknown runtime: {runtime_id}", operation))

        capability_id = action.get("capability_id")
        capability = self.state.capabilities.get(capability_id)
        if capability is None:
            errors.append(shell_error(UNKNOWN_CAPABILITY, f"unknown capability: {capability_id}", operation))

        permission_id = action.get("permission_id")
        permission = self.state.permissions.get(permission_id)
        if permission is None:
            errors.append(shell_error(UNKNOWN_PERMISSION, f"unknown permission: {permission_id}", operation))
        elif permission.get("decision") not in ALLOWED_PERMISSION_DECISIONS:
            errors.append(
                shell_error(
                    PERMISSION_DENIED,
                    f"permission decision is not allow or approved: {permission.get('decision')}",
                    operation,
                )
            )

        if permission is not None and capability_id is not None and permission.get("capability_id") != capability_id:
            errors.append(
                shell_error(
                    PERMISSION_DENIED,
                    "permission does not authorize the requested capability",
                    operation,
                )
            )

        approval_id = action.get("approval_id")
        if approval_id is None:
            errors.append(shell_error(APPROVAL_MISSING, "approval_id is required", operation))
        else:
            approval = self.state.approvals.get(approval_id)
            if approval is None:
                errors.append(shell_error(APPROVAL_MISSING, f"unknown approval: {approval_id}", operation))
            elif approval.get("status") != "approved":
                errors.append(shell_error(APPROVAL_NOT_VALID, f"approval is not approved: {approval_id}", operation))

        audit_event = action.get("audit_event")
        if not isinstance(audit_event, dict):
            errors.append(shell_error(AUDIT_MAPPING_MISSING, "audit_event is required", operation))
        else:
            if not audit_event.get("event_id"):
                errors.append(shell_error(AUDIT_MAPPING_MISSING, "audit_event.event_id is required", operation))
            if self._has_payload(action) and not audit_event.get("payload_hash"):
                errors.append(shell_error(AUDIT_MAPPING_MISSING, "audit_event.payload_hash is required when payload exists", operation))

        recovery_action = action.get("recovery_action")
        if not isinstance(recovery_action, dict) or not recovery_action.get("recovery_id"):
            errors.append(shell_error(RECOVERY_MAPPING_MISSING, "recovery_action.recovery_id is required", operation))
        elif recovery_action["recovery_id"] not in self.state.recovery_actions:
            errors.append(
                shell_error(
                    RECOVERY_MAPPING_MISSING,
                    f"unknown recovery action: {recovery_action['recovery_id']}",
                    operation,
                )
            )

        if self._metadata_claims_authority(action.get("adapter_metadata", {})):
            errors.append(
                shell_error(
                    ADAPTER_METADATA_ESCALATION_ATTEMPT,
                    "adapter metadata attempted to claim authority",
                    operation,
                )
            )

        for source in sorted(NON_AUTHORITY_SOURCES):
            if action.get("authority_source") == source or action.get(f"{source}_grants_authority") is True:
                errors.append(shell_error(NON_AUTHORITY_SOURCE_ATTEMPT, f"{source} cannot grant authority", operation))

        return {
            "allowed": not errors,
            "errors": errors,
            "required_recovery": recovery_action if errors and isinstance(recovery_action, dict) else None,
            "audit_required": True,
        }

    def _has_payload(self, action: dict) -> bool:
        return any(key in action for key in ("payload", "full_payload", "redacted_payload"))

    def _metadata_claims_authority(self, value) -> bool:
        stripped = strip_authority_keys(value)
        return bool(authority_keys_in(value) or authority_values_in(stripped))
