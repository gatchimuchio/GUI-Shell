# GUI-Shell Completion Strategy Instruction

Status: v1.0 product-completion skeleton, not production runtime  
Repository: `gatchimuchio/GUI-Shell`  
Primary goal: complete GUI-Shell as a desktop-first AI Runtime / Agent Operation Shell.  
Reference consumer/runtime: BLUE-TANUKI through adapter contract only.  

## 0. Current Position

GUI-Shell currently has:

- Phase 0 standard / selection lock
- Phase 1 schema / contract skeleton
- Phase 2 conformance skeleton
- Phase 3H Shell Core hardening skeleton
- Phase 4 Rust helper boundary skeleton
- Phase 5 BLUE-TANUKI mock reference adapter skeleton
- Phase 6 Desktop Flutter operator shell skeleton
- Phase 7 Installer / Setup Doctor skeleton
- Phase 8 Mobile companion skeleton
- Phase 9 release-hardening documents
- 19 schemas
- 19 valid examples
- 19 negative fixtures
- 67 conformance checks

Current claim boundary:

```text
v1.0 product-completion skeleton exists.
Not yet a production Shell Core runtime.
Not yet a complete Rust helper.
Not yet a live BLUE-TANUKI adapter.
Not yet a complete product GUI.
Not yet installer/mobile/release ready.
```

## 1. Non-Negotiable Rules

Follow these rules throughout all phases:

1. Safety first.
2. Robustness second.
3. Operator clarity / UX third.
4. Product features fourth.
5. Convenience last.

Do not weaken authority boundaries for comfort.

Do not import Flutter into Shell Core.

Do not import BLUE-TANUKI internals into Shell Core.

Do not modify BLUE-TANUKI Core for GUI-Shell convenience unless explicitly instructed by the owner.

Do not treat adapter metadata, memory, cache, previous state, local UI state, installer state, or mobile state as authority.

Every sensitive action must map to:

- Capability
- Permission
- Approval state
- AuditEvent
- RecoveryAction

Never claim validation passed unless it actually passed.

## 2. Implemented Skeleton Map

### Shell Core

Relevant files:

- `packages/shell_core/error_taxonomy.py`
- `packages/shell_core/policy_evaluator.py`
- `packages/shell_core/runtime_state.py`
- `packages/shell_core/state_snapshot.py`
- `packages/shell_core/permission_ledger.py`
- `packages/shell_core/approval_queue.py`
- `packages/shell_core/audit_store.py`
- `packages/shell_core/recovery_catalog.py`

The Shell Core skeleton must remain framework-independent and BLUE-TANUKI-internal-free.

### Rust Helper

Relevant files:

- `native/rust_helper/src/lib.rs`
- `native/rust_helper/src/process.rs`
- `native/rust_helper/src/filesystem.rs`
- `native/rust_helper/src/network.rs`
- `native/rust_helper/src/diagnostics.rs`
- `native/rust_helper/src/update_verification.rs`
- `native/rust_helper/src/audit_hash.rs`
- `native/rust_helper/src/ipc.rs`

The Rust helper is a bounded helper surface only. It must not become an authority path.

### BLUE-TANUKI Adapter

Relevant files:

- `packages/blue_tanuki_adapter/adapter.py`
- `packages/blue_tanuki_adapter/health.py`
- `packages/blue_tanuki_adapter/runtime_snapshot.py`
- `packages/blue_tanuki_adapter/authority_trace.py`
- `packages/blue_tanuki_adapter/notifications.py`
- `packages/blue_tanuki_adapter/approvals.py`
- `packages/blue_tanuki_adapter/audit_export.py`
- `packages/blue_tanuki_adapter/diagnostics.py`
- `packages/blue_tanuki_adapter/recovery.py`

The current adapter is mock-contract based. Live runtime integration is not complete.

### Desktop Flutter

Relevant files:

- `apps/desktop_flutter/lib/main.dart`
- `apps/desktop_flutter/lib/screens/`
- `apps/desktop_flutter/lib/services/shell_core_client.dart`
- `apps/desktop_flutter/lib/models/generated_contracts.dart`

Flutter is an operator surface only. It must not define authority, permission semantics, approval semantics, audit semantics, or recovery semantics.

### Installer / Setup Doctor

Relevant files:

- `installer/setup_doctor.py`
- `docs/FIRST_RUN.md`
- `docs/SETUP_DOCTOR.md`
- `docs/INSTALLER_BOUNDARY.md`

Installer state must never grant authority or silently approve permissions.

### Mobile Companion

Relevant files:

- `apps/mobile_flutter/lib/main.dart`
- `apps/mobile_flutter/lib/screens/`

Mobile may observe, review, notify, request emergency stop, and show recovery instructions. It must not become independent authority.

### Release Hardening

Relevant files:

- `RELEASE_CHECKLIST.md`
- `SECURITY_REVIEW.md`
- `COMPATIBILITY_MATRIX.md`
- `CONFORMANCE_REPORT.md`
- `AUDIT_EVIDENCE.md`
- `INSTALLER_STATUS.md`
- `MOBILE_STATUS.md`
- `VALIDATION.txt`

Release claim promotion requires owner GO and direct evidence.

## 3. Immediate Next Work

Continue from skeleton to production-grade behavior in this order:

```text
1. Make Rust helper compile and pass cargo test.
2. Run Flutter analyze for desktop and mobile.
3. Replace mock Shell Core client with a real local Shell Core boundary.
4. Add durable audit storage and hash-chain verification.
5. Add live BLUE-TANUKI adapter integration through generic contracts only.
6. Add installer packaging after Setup Doctor behavior is stable.
7. Add real mobile pairing with audit, revocation, and recovery path.
8. Re-run release claim review after evidence exists.
```

Do not skip toolchain validation. If a tool is unavailable, report `not run` with the exact reason.

## 4. Production-Hardening Requirements

### 4.1 Policy Evaluation

`PolicyEvaluator` must reject:

- unknown runtime
- unknown capability
- unknown permission
- denied permission
- missing approval
- invalid approval state
- missing audit event
- missing audit payload hash when payload exists
- missing recovery action
- adapter metadata authority claims
- non-authority source attempts

Output shape:

```python
{
  "allowed": bool,
  "errors": [...],
  "required_recovery": dict | None,
  "audit_required": bool
}
```

### 4.2 State Snapshot

State snapshots must be deterministic and include:

- runtimes
- adapters
- permissions
- pending approvals
- audit summary
- recovery catalog summary
- update policy summary
- invariant flags

Invariant flags must include:

```text
flutter_imported_by_shell_core=false
blue_tanuki_imported_by_shell_core=false
adapter_metadata_can_escalate_authority=false
memory_cache_previous_state_can_grant_authority=false
full_payload_projected_without_full_visibility=false
```

### 4.3 Rust Helper

Allowed responsibilities:

- process diagnostics
- filesystem diagnostics
- port/network diagnostics
- audit hash utilities
- update signature verification
- secure IPC message framing
- recovery helper stubs

Forbidden:

- becoming an authority path
- arbitrary command execution
- arbitrary file content read by default
- arbitrary file write
- arbitrary external fetch by default
- credential access without explicit contract
- bypassing audit
- bypassing recovery mapping

Helper response shape:

```json
{
  "ok": true,
  "operation": "string",
  "result": {},
  "diagnostics": [],
  "error": null
}
```

Failure shape:

```json
{
  "ok": false,
  "operation": "string",
  "result": null,
  "diagnostics": [],
  "error": {
    "code": "string",
    "message": "string",
    "recoverable": true
  }
}
```

### 4.4 BLUE-TANUKI Adapter

Adapter surfaces:

- health
- ready
- runtime snapshot
- authority trace
- notifications
- approvals
- audit events
- diagnostics export
- recovery actions

Rules:

- Runtime-specific mapping stays inside `packages/blue_tanuki_adapter/`.
- Adapter metadata remains untrusted.
- Adapter cannot grant permission.
- Adapter cannot approve actions.
- Adapter cannot bypass content exposure policy.
- Adapter cannot bypass audit.

If BLUE-TANUKI runtime is unavailable, use mock fixtures. Do not block contract tests on live runtime.

### 4.5 Flutter Desktop

Required screens:

- Dashboard
- Setup Doctor
- Runtime Center
- Permission Center
- Approval Center
- Audit Viewer
- Recovery Center
- Settings

UI forbidden rules:

- Flutter must not define authority.
- Flutter must not define permission semantics.
- Flutter must not approve without Shell Core.
- Flutter must not display `full_payload` unless Shell Core projection allows it.
- Flutter must not bypass adapter conformance.
- Flutter must not bypass audit creation.
- Flutter must not mutate protected approval fields.

### 4.6 Installer / Setup Doctor

Setup Doctor must check:

- Python availability
- Rust availability when needed
- Flutter availability when needed
- runtime connection
- local permissions
- update policy
- audit storage
- recovery catalog
- adapter readiness

Rules:

- Installer state must not grant authority.
- Installer must not silently approve permissions.
- Installer must not hide failures.
- Failure messages must be operator-readable.

### 4.7 Mobile Companion

Mobile allowed:

- view runtime status
- receive notifications
- review approvals
- request emergency stop
- view recovery instructions

Mobile forbidden:

- bypass Shell Core
- bypass approval visibility
- bypass protected field rules
- become independent authority
- silently pair devices
- approve hidden payloads

Device pairing must include:

- device_id
- pairing_id
- operator confirmation
- audit event
- revocation path
- recovery path

## 5. Validation Commands

Always run:

```bash
python3 tooling/schema_check/check_schemas.py
python3 tooling/conformance_tests/run_conformance_skeleton.py
```

Aggregate reporter:

```bash
python3 tooling/validate_all.py
```

When Rust is available:

```bash
cd native/rust_helper && cargo test
```

When Flutter is available:

```bash
cd apps/desktop_flutter && flutter analyze
cd apps/mobile_flutter && flutter analyze
```

Current known environment result:

```text
schema check passed: 19 schemas, 19 examples, 19 negative fixtures
conformance skeleton passed: 67 checks
cargo test: not run, cargo not found on PATH
desktop flutter analyze: not run, flutter not found on PATH
mobile flutter analyze: not run, flutter not found on PATH
```

## 6. Release Claim Rules

Do not claim:

- production readiness
- installer readiness
- mobile readiness
- stable runtime support
- security completeness

unless evidence exists.

Owner GO is required before any release claim promotion.

## 7. Required Final Report Format

Every completed work block must report:

1. Summary
2. Changed files
3. Risk classification
4. Validation results
5. Remaining risks
6. Commit hash, or `not committed`

Validation must explicitly say:

- passed
- failed
- not run
- exact command
- exact reason if not run
