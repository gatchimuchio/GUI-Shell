# GUI Shell Operating Model

Status: Phase 9 release-hardening skeleton operating model  
Reference style: BLUE-TANUKI direct-main owner workflow  
Scope: repository flow, safety posture, validation, backup, and reporting

## 1. Core posture

GUI Shell is a control plane, not a visual wrapper.

The repository must move in this order:

```text
standard
  -> schema
  -> conformance
  -> Shell Core
  -> adapter
  -> Rust helper
  -> product UI
  -> installer / update
  -> mobile companion
  -> release hardening
```

Later phases must not weaken earlier guarantees.

## 2. Priority order

1. Safety
2. Robustness
3. Operator clarity / UX
4. Product features
5. Convenience

Feature coverage and convenience are not valid reasons to weaken authority strip, content exposure, approval, audit, recovery, or schema validation.

## 3. Boundary model

```text
Runtime
  -> Adapter
      -> schema validation
      -> authority strip
      -> content exposure policy
  -> Shell Core
      -> permission
      -> approval
      -> audit
      -> recovery
  -> UI
      -> display
      -> operator input
  -> Rust helper
      -> bounded native operation
```

The UI can request and display. It cannot grant authority.

Adapter metadata can describe. It cannot grant permissions.

Memory, cache, and previous state can inform UX. They cannot grant authority by themselves.

## 4. Backup workflow

GUI Shell uses the same two-generation direct-main backup flow as BLUE-TANUKI.

Before committing a completed work block on `main`:

```bash
# If codex/backup-main already exists:
git branch -f codex/backup-main-prev codex/backup-main

# Always update the latest backup to the current pre-commit main:
git branch -f codex/backup-main main
```

Push when credentials allow:

```bash
git push -f origin codex/backup-main-prev
git push -f origin codex/backup-main
```

Then validate, commit directly on `main`, and push `main` when credentials allow.

The repository keeps exactly two backup branches:

```text
codex/backup-main
codex/backup-main-prev
```

Do not create per-phase backup branches or extra backup generations.

## 5. Validation gates

Minimum validation:

```bash
python tooling/schema_check/check_schemas.py
python tooling/conformance_tests/run_conformance_skeleton.py
```

Fallback when `python` is unavailable:

```bash
python3 tooling/schema_check/check_schemas.py
python3 tooling/conformance_tests/run_conformance_skeleton.py
```

Conditional checks:

```bash
cd native/rust_helper && cargo test
cd apps/desktop_flutter && flutter analyze
```

Report every command as passed, failed, or not run.

## 6. Change report format

Every completed change report must include:

1. Summary
2. Changed files
3. Risk classification
4. Validation results
5. Remaining risks
6. Commit hash, or `not committed`

## 7. Release claim rule

Do not claim release readiness until all applicable validation gates pass and the owner explicitly approves the release claim.

Current claim boundary lives in:

```text
CLAIM.md
```
