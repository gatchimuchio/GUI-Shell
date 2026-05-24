# GUI Shell Audit

GUI Shell audit expectations are schema-first and conformance-first.

## Required audit mapping

Every sensitive action must map to:

- capability;
- permission;
- approval state;
- `AuditEvent`;
- `RecoveryAction` on failure.

## Core invariant checks

The repository must preserve these invariants:

- inbound authority keys are stripped;
- external metadata cannot escalate authority;
- runtime-disallowed authority context cannot be created by GUI input;
- GUI input is not authority;
- memory, cache, and previous state are not authority by themselves;
- content visibility is respected;
- approval edits are field-scoped;
- edited payloads are rehashed and revalidated;
- all sensitive actions create audit events.

## Contract surfaces

Audit-related contracts live in:

```text
specs/audit.schema.json
specs/approval.schema.json
specs/capability.schema.json
specs/permission.schema.json
specs/recovery.schema.json
docs/specs/adapter-conformance.md
docs/specs/approval-visibility-boundary.md
docs/specs/content-exposure-policy.md
```

## Validation

```bash
python tooling/schema_check/check_schemas.py
python tooling/conformance_tests/run_conformance_skeleton.py
```

The conformance skeleton is not a complete audit implementation. It is the first gate that prevents product UI from outrunning authority, visibility, approval, and recovery contracts.
