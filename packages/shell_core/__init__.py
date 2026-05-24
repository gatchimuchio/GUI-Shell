"""Framework-independent Shell Core skeleton."""

from .adapter_loader import AdapterRecord, load_adapter
from .approval_queue import ApprovalQueue
from .audit_store import AuditStore
from .content_exposure import project_approval_content
from .error_taxonomy import ShellCoreError, shell_error
from .permission_ledger import PermissionLedger
from .policy_evaluator import PolicyEvaluator
from .recovery_catalog import RecoveryCatalog
from .runtime_state import RuntimeState
from .runtime_registry import RuntimeRegistry
from .sensitive_action_router import SensitiveActionRouter
from .state_snapshot import create_state_snapshot, deterministic_snapshot_json
from .update_policy_store import UpdatePolicyStore

__all__ = [
    "AdapterRecord",
    "ApprovalQueue",
    "AuditStore",
    "PermissionLedger",
    "PolicyEvaluator",
    "RecoveryCatalog",
    "RuntimeRegistry",
    "RuntimeState",
    "SensitiveActionRouter",
    "ShellCoreError",
    "UpdatePolicyStore",
    "create_state_snapshot",
    "deterministic_snapshot_json",
    "load_adapter",
    "project_approval_content",
    "shell_error",
]
