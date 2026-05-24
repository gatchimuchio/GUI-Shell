# GUI Shell

GUI Shell is a generic Runtime Operation Shell for local runtimes, agents, tools, and services.

It is **not** a BLUE-TANUKI-specific GUI. BLUE-TANUKI is the first reference runtime and must connect through an adapter boundary.

## TL;DR

1. **GUI Shell is a control plane.** Flutter renders operator surfaces; it does not own authority.
2. **Schemas and conformance own the contract.** Runtime, adapter, permission, approval, audit, recovery, and content exposure semantics are JSON Schema-first.
3. **Safety first, robustness second, product UI third.** Product screens never outrank authority strip, content exposure, approval, audit, and recovery boundaries.

## Phase 0 locked surface

- Generic Runtime Operation Shell direction
- BLUE-TANUKI is frozen as the Phase 0 reference runtime contract target through adapter only
- Flutter + Rust helper as primary implementation candidate
- Compose Multiplatform watchlist
- Tauri desktop-heavy fallback
- FrameworkRiskProfile for UI framework governance risk
- Adapter Conformance requirements
- Content Exposure Boundary
- Authority Strip Conformance
- Schema-first / conformance-first work order

## Explicit boundaries

- Shell Core must not contain BLUE-TANUKI-specific logic.
- Flutter-specific code must not define core contracts or authority decisions.
- Adapter metadata is untrusted and must never grant permissions.
- Memory, local cache, and previous state must never grant authority by themselves.
- Full content may be displayed only when `content_visibility=full`.
- Approval payload fields marked authority, sealed, hidden, or sacred are not editable.
- Sensitive actions must map to capability, permission, approval state, audit event, and recovery action.
- Network, filesystem, process, credential, and IPC access must not be silently introduced or broadened.

## Architecture

```text
Runtime / Agent / Tool / Local Service
  -> Adapter
      -> authority strip
      -> content exposure policy
      -> schema validation
      -> capability declaration
  -> Shell Core
      -> runtime registry
      -> permission ledger
      -> approval queue
      -> audit events
      -> recovery actions
  -> UI Layer
      -> Flutter rendering
      -> operator input
      -> navigation and local UI state
  -> Rust Helper
      -> bounded native diagnostics and operations
```

The UI can display and request actions. It cannot create authority, bypass adapter conformance, or reinterpret runtime trust.

## Quickstart

Validation checks the repository contracts and conformance skeleton. This skeleton does not assume Flutter or Rust is already installed.

```bash
python tooling/schema_check/check_schemas.py
python tooling/conformance_tests/run_conformance_skeleton.py
```

If the host only exposes Python as `python3`, use:

```bash
python3 tooling/schema_check/check_schemas.py
python3 tooling/conformance_tests/run_conformance_skeleton.py
```

Expected successful output:

```text
schema check passed: 11 schemas, 11 examples, 11 negative fixtures
conformance skeleton passed: 55 checks
```

See [QUICKSTART.md](./QUICKSTART.md).

## Validation

Required before reporting implementation work:

```bash
python tooling/schema_check/check_schemas.py
python tooling/conformance_tests/run_conformance_skeleton.py
```

Conditional toolchain checks:

```bash
cd native/rust_helper && cargo test
cd apps/desktop_flutter && flutter analyze
cd apps/mobile_flutter && flutter analyze
```

Or run the aggregate reporter:

```bash
python3 tooling/validate_all.py
```

See [VALIDATION.txt](./VALIDATION.txt) for the last recorded validation output.

## Repository layout

```text
docs/
  standards/
  research/
  specs/

specs/
  *.schema.json

apps/
  desktop_flutter/
  mobile_flutter/

packages/
  shell_core/
  shell_ui/
  shell_contracts/
  blue_tanuki_adapter/

native/
  rust_helper/

installer/
  windows/
  macos/
  linux/

tooling/
  codegen/
  schema_check/
  conformance_tests/
  ui_snapshot_tests/
```

## Current status

This repository is a Phase 9 release-hardening skeleton, not a production runtime.

It intentionally prioritizes:

1. standards
2. specs
3. conformance boundaries
4. runtime adapter contracts
5. helper boundaries

before product UI.

## Top-level references

- [AGENTS.md](./AGENTS.md): repository agent rules
- [ROADMAP.md](./ROADMAP.md): phase roadmap and execution order
- [docs/OPERATING_MODEL.md](./docs/OPERATING_MODEL.md): repository flow, backup model, and validation gates
- [CLAIM.md](./CLAIM.md): current claim boundary
- [CONFIG.md](./CONFIG.md): configuration reference
- [AUDIT.md](./AUDIT.md): audit and invariant expectations
- [SECURITY.md](./SECURITY.md): security posture and reporting
- [TROUBLESHOOTING.md](./TROUBLESHOOTING.md): validation and setup failure guide
