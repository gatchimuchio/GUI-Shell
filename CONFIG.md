# GUI Shell Configuration

This file is the Phase 0 / Phase 1 configuration reference. It describes intended configuration surfaces without granting authority by configuration alone.

## Validation commands

```bash
python tooling/schema_check/check_schemas.py
python tooling/conformance_tests/run_conformance_skeleton.py
```

If needed:

```bash
python3 tooling/schema_check/check_schemas.py
python3 tooling/conformance_tests/run_conformance_skeleton.py
```

## Runtime adapter configuration

Adapters are declared by schema and conformance rules. Adapter metadata is untrusted.

Required adapter properties are defined in:

```text
specs/adapter.schema.json
docs/specs/adapter-conformance.md
```

Adapter configuration must not:

- grant permission by metadata;
- create authority context not allowed by the runtime;
- bypass content exposure policy;
- bypass approval state;
- silently add network, filesystem, process, credential, or IPC access.

## Content exposure configuration

Content visibility values are:

```text
none
hash_only
summary
redacted
full
```

Only `full` permits full content display. Other modes must display only the allowed projection.

## Native helper configuration

The Rust helper boundary is reserved for bounded native diagnostics and operations:

- process checks;
- filesystem diagnostics;
- network diagnostics;
- update verification;
- audit hashing;
- secure IPC.

Native helper configuration must remain subordinate to capability, permission, approval, audit, and recovery contracts.
