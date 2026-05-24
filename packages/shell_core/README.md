# shell_core

Framework-independent Shell Core.

Owns:

- runtime registry semantics
- permission ledger semantics
- approval queue semantics
- audit event creation
- recovery classification
- content exposure validation
- framework risk profile handling

Must not depend on Flutter.

Phase 3 skeleton modules:

- `runtime_registry`
- `adapter_loader`
- `permission_ledger`
- `approval_queue`
- `audit_store`
- `recovery_catalog`
- `update_policy_store`
- `content_exposure`

The implementation is intentionally minimal and deterministic. It does not import Flutter or BLUE-TANUKI internals.
