# GUI Shell Quickstart

GUI Shell is currently a release-hardening skeleton, not a production runtime. The quickstart path validates contracts and conformance scaffolding before product claims.

## Prerequisites

- A POSIX-like shell
- Python available as `python` or `python3`
- Optional: Rust for `native/rust_helper`
- Optional: Flutter for `apps/desktop_flutter` and `apps/mobile_flutter`

## Contract validation

Preferred commands:

```bash
python tooling/schema_check/check_schemas.py
python tooling/conformance_tests/run_conformance_skeleton.py
```

Fallback when `python` is not on `PATH`:

```bash
python3 tooling/schema_check/check_schemas.py
python3 tooling/conformance_tests/run_conformance_skeleton.py
```

Expected successful output:

```text
schema check passed: 19 schemas, 19 examples, 19 negative fixtures
conformance skeleton passed: 67 checks
```

## Optional Rust helper check

```bash
cd native/rust_helper
cargo test
```

The Rust helper is a bounded native helper surface. It must not become the hidden authority path for runtime permissions.

## Optional Flutter check

```bash
cd apps/desktop_flutter
flutter analyze
```

```bash
cd apps/mobile_flutter
flutter analyze
```

Flutter is the replaceable UI layer. UI widgets may collect operator input and render status, but they must not define authority, permission, approval, audit, or recovery semantics.

## Next implementation order

1. Keep `docs/standards/gui-shell-extended-standard.md` authoritative.
2. Extend JSON Schemas under `specs/`.
3. Add or update conformance tests.
4. Generate or update contracts.
5. Keep claim documents aligned with actual validation evidence.
