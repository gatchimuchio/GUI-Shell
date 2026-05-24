# GUI Shell

GUI Shell is a generic Runtime Operation Shell for AI-agent runtimes and local tools.

It is **not** a BLUE-TANUKI-specific GUI. BLUE-TANUKI is treated as the first reference runtime through an adapter boundary.

## Phase 0 Lock

Primary decision:

- UI framework: Flutter
- Native helper: Rust
- Contracts: JSON Schema / OpenAPI-ready
- Reference runtime: BLUE-TANUKI via adapter
- BLUE-TANUKI implementation: frozen
- Strategy: schema-first / conformance-first

## Non-negotiable principles

- Do not place core assets inside Flutter-specific code.
- Do not implement BLUE-TANUKI-specific logic in Shell Core.
- Do not allow external metadata to escalate authority.
- Do not expose raw content unless Content Exposure Policy permits it.
- Do not start product UI before schemas and conformance tests exist.
- Treat Flutter as a replaceable UI layer, not the system core.

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

## Initial commands

This skeleton does not assume Flutter or Rust is already installed.

```bash
python tooling/schema_check/check_schemas.py
python tooling/conformance_tests/run_conformance_skeleton.py
```

After Flutter/Rust setup:

```bash
cd apps/desktop_flutter
flutter pub get
flutter run

cd ../../native/rust_helper
cargo test
```

## Current status

This repository is a Phase 0 / Phase 1 skeleton.

It intentionally prioritizes:

1. standards
2. specs
3. conformance boundaries
4. runtime adapter contracts
5. helper boundaries

before product UI.
