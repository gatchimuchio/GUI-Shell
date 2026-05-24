# Repository Agent Instructions

## Scope

This repository implements a generic GUI Shell / Runtime Operation Shell.

The repository-local instructions in this file are authoritative.

## Core rule

Treat GUI Shell as a **control plane**, not a visual wrapper.

## Required implementation order

1. Read `docs/standards/gui-shell-extended-standard.md`.
2. Check the JSON Schemas under `specs/`.
3. Preserve Shell Core / UI / Adapter / Rust helper boundaries.
4. Add or update conformance tests before product UI.
5. Keep Flutter-specific code out of core contracts.
6. Keep BLUE-TANUKI-specific logic out of Shell Core.

## Architecture constraints

- UI framework: Flutter.
- Native helper: Rust.
- Contracts: JSON Schema.
- Reference runtime: BLUE-TANUKI via adapter.
- BLUE-TANUKI implementation is frozen.
- Flutter is replaceable UI, not core system authority.

## Forbidden changes

- Do not put authority decisions in UI widgets.
- Do not let adapter metadata grant permissions.
- Do not let memory, local cache, or previous state grant authority by itself.
- Do not display full content unless `content_visibility=full`.
- Do not edit authority, sealed, hidden, or sacred fields in approval payloads.
- Do not introduce hidden network, filesystem, process, credential, or IPC access.
- Do not silently broaden runtime permissions.

## Required audit behavior

Every sensitive action must map to:

- Capability
- Permission
- Approval state
- AuditEvent
- RecoveryAction on failure

## Validation before final report

Run at minimum:

```bash
python tooling/schema_check/check_schemas.py
python tooling/conformance_tests/run_conformance_skeleton.py
```

If Rust is installed:

```bash
cd native/rust_helper && cargo test
```

If Flutter is installed:

```bash
cd apps/desktop_flutter && flutter analyze
```

Report which commands passed, failed, or were not run.
