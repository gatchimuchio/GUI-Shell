"""Framework-independent Shell Core skeleton."""

from .adapter_loader import AdapterRecord, load_adapter
from .approval_queue import ApprovalQueue
from .audit_store import AuditStore
from .content_exposure import project_approval_content
from .permission_ledger import PermissionLedger
from .recovery_catalog import RecoveryCatalog
from .runtime_registry import RuntimeRegistry
from .sensitive_action_router import SensitiveActionRouter
from .update_policy_store import UpdatePolicyStore

__all__ = [
    "AdapterRecord",
    "ApprovalQueue",
    "AuditStore",
    "PermissionLedger",
    "RecoveryCatalog",
    "RuntimeRegistry",
    "SensitiveActionRouter",
    "UpdatePolicyStore",
    "load_adapter",
    "project_approval_content",
]
