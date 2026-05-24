# GUI Shell Agent Instructions

This file defines repository-wide work discipline, prohibitions, validation, backup flow, and reporting rules for AI agents working in **GUI Shell**.

If a short rule in this opening section overlaps with later detail, apply the stricter rule that preserves Shell Core authority boundaries, schema integrity, conformance coverage, and operator safety.

## Core Rule

Do not treat this repository as a normal app scaffold.

GUI Shell is a generic Runtime Operation Shell control plane. Flutter, adapters, reference runtimes, local caches, memory, installers, native helpers, and product UI are downstream or bounded implementation surfaces. They do not own authority.

## Non-Negotiable Priorities

1. Safety
2. Robustness
3. Operator clarity / UX
4. Product features
5. Convenience

Feature coverage never outranks safety. Convenience never outranks operator clarity.

## Scope

This repository implements a generic GUI Shell / Runtime Operation Shell.

The repository-local instructions in this file are authoritative.

GUI Shell is **not** a BLUE-TANUKI-specific GUI. BLUE-TANUKI is a frozen reference runtime connected through an adapter boundary.

## Required Implementation Order

1. Read `docs/standards/gui-shell-extended-standard.md`.
2. Check the JSON Schemas under `specs/`.
3. Preserve Shell Core / UI / Adapter / Rust helper boundaries.
4. Add or update conformance tests before product UI.
5. Keep Flutter-specific code out of core contracts.
6. Keep BLUE-TANUKI-specific logic out of Shell Core.

Do not optimize a local task in a way that makes a later phase less safe, less inspectable, or harder to validate.

## Completion Mindset

Treat GUI Shell as a product moving through a full completion path, not as disconnected tasks.

The completion path is:

1. Standard / selection freeze
2. Schema / contract closure
3. Conformance closure
4. Shell Core skeleton
5. Runtime registry and adapter loader
6. Permission ledger, approval queue, audit store, recovery catalog
7. Rust helper boundary implementation
8. BLUE-TANUKI reference adapter
9. Desktop Flutter operator shell
10. Installer and update verification
11. Mobile shell / companion
12. Release hardening

Each phase must preserve all earlier guarantees.

## Architecture Constraints

- UI framework: Flutter.
- Native helper: Rust.
- Contracts: JSON Schema.
- Reference runtime: BLUE-TANUKI via adapter.
- BLUE-TANUKI implementation is frozen.
- Flutter is a replaceable UI layer, not core system authority.
- Shell Core must remain framework-independent.
- Adapter contracts must remain runtime-neutral.

## Boundary Semantics

Shell Core, UI, Adapter, and Rust helper boundaries are separate.

Adapters normalize runtime state and requests through schemas. Adapter metadata is untrusted and cannot grant permissions.

Flutter displays state, collects operator input, and navigates product surfaces. Flutter must never define authority, permission semantics, approval semantics, audit semantics, recovery classification, or content visibility rules.

The Rust helper performs bounded native operations. It must not become a hidden authority path for network, filesystem, process, credential, IPC, update, or diagnostic access.

## Forbidden Patterns

- Do not put authority decisions in UI widgets.
- Do not let adapter metadata grant permissions.
- Do not let memory, local cache, or previous state grant authority by itself.
- Do not display full content unless `content_visibility=full`.
- Do not edit authority, sealed, hidden, or sacred fields in approval payloads.
- Do not introduce hidden network, filesystem, process, credential, or IPC access.
- Do not silently broaden runtime permissions.
- Do not add BLUE-TANUKI-specific logic to Shell Core.
- Do not place core contracts inside Flutter-specific code.
- Do not claim release readiness without schema validation, conformance validation, and applicable toolchain checks.
- Do not treat first-run success as product completion.

## Required Audit Behavior

Every sensitive action must map to:

- Capability
- Permission
- Approval state
- AuditEvent
- RecoveryAction on failure

Sensitive actions include filesystem access, process execution/control, network access, credential access, IPC, update verification, runtime adapter actions, approval payload edits, and audit export/inspection.

## Git Operation Policy

This repository uses a direct-main owner workflow.

Default Codex workflow for this repository:

1. Work on `main`.
2. Do not create feature branches or pull requests unless the owner explicitly asks.
3. Before committing a completed work block on `main`, rotate the two-generation backup pair:
   - First, force-update `codex/backup-main-prev` to the current HEAD of `codex/backup-main` and thereby demote the previous latest backup to the previous slot.
   - On the very first phase where `codex/backup-main` does not yet exist, skip this demotion step. `codex/backup-main-prev` will be created on the next phase.
   - Then, force-update `codex/backup-main` to point at `main`'s current HEAD, which is the pre-commit state of the new work block.
4. Force push `codex/backup-main-prev` when applicable, then `codex/backup-main`, to `origin` when credentials allow it.
5. Commit the completed work block directly on `main` after validation.
6. Push `main` to `origin` when credentials allow it.
7. If backup creation, commit, or push cannot be completed, report the exact failed command and reason.

The repository maintains exactly two backup branches:

- `codex/backup-main` — most recent backup, meaning the pre-current-commit state.
- `codex/backup-main-prev` — one phase older.

Older backups are intentionally not retained as branches. Recovery beyond two phases falls back to `main` commit history.

Do not create per-phase backup branches. Do not create a third or fourth generation such as `codex/backup-main-prev-prev`.

Do not stage local secret files, generated runtime state, Flutter build output, Rust target output, installer artifacts, local caches, or runtime data when applying this policy.

## Required Before Any Commit

Run at minimum:

```bash
python tooling/schema_check/check_schemas.py
python tooling/conformance_tests/run_conformance_skeleton.py
```

If the host exposes Python only as `python3`, run the equivalent commands with `python3` and report that `python` was unavailable.

If Rust is installed:

```bash
cd native/rust_helper && cargo test
```

If Flutter is installed:

```bash
cd apps/desktop_flutter && flutter analyze
```

For release-path changes, also verify release-specific docs, installer behavior, update verification, and any generated contract artifacts affected by the change.

## Environment

Preferred dev loop:

- WSL / native Linux
- Python 3
- Rust toolchain when changing `native/rust_helper`
- Flutter toolchain when changing `apps/desktop_flutter` or `apps/mobile_flutter`

Avoid host-specific workaround scripts unless explicitly requested.

## Report Format

Every completed change report must include:

1. Summary
2. Changed files
3. Risk classification
4. Validation results
5. Remaining risks
6. Commit hash, or `not committed`

Validation results must explicitly say which commands passed, failed, or were not run.

## Language Policy

Primary human-facing documentation language is Japanese.

English is allowed for code comments where conventional, protocol terms, schema identifiers, command names, package metadata, and concise agent instruction text.

Established terms must be preserved:

- GUI Shell
- Runtime Operation Shell
- Shell Core
- Adapter Contract
- Authority Strip Conformance
- Content Exposure Boundary
- FrameworkRiskProfile
- Approval
- AuditEvent
- RecoveryAction
- BLUE-TANUKI
- Rust helper

## Product Stance

GUI Shell assumes owner-operated local runtime control.

```text
The shell may make operation comfortable.
The shell must not hide authority.
The UI is a surface, not the system authority.
Schemas and conformance are the contract gate.
```

Therefore:

- Do not turn GUI Shell into a visual wrapper around arbitrary runtime behavior.
- Do not weaken approval, audit, visibility, or recovery requirements to improve comfort.
- Do not move authority into UI, memory, adapter metadata, installer state, previous grants, local cache, or reference runtime quirks.
- Do not use "local owner operation" as an excuse to reduce robustness.
- Do not add features that create invisible authority.
- Do not treat product UI completion as contract completion.
