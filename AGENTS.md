# GUI Shell Agent Instructions

This file defines repository-wide work discipline for AI agents working in GUI Shell.

## 0. Core Rule

Do not treat this repository as a normal app scaffold.

GUI Shell is a generic Runtime Operation Shell control plane. Flutter, adapters, reference runtimes, local caches, memory, installers, native helpers, and product UI are downstream or bounded implementation surfaces. They do not own authority.

## 1. Non-Negotiable Priorities

Apply this priority order:

1. Safety
2. Robustness
3. Operator clarity / UX
4. Product features
5. Convenience

Convenience never outranks operator clarity.
Feature completion never outranks safety, auditability, recovery, or authority boundaries.

## 2. Scope

GUI Shell implements a generic GUI Shell / Runtime Operation Shell.

It is not a BLUE-TANUKI-specific GUI.

BLUE-TANUKI is the first reference runtime and must connect through an adapter boundary.

## 3. Source of Truth

When working in this repository, follow this order of authority:

1. Explicit owner instruction in the current task
2. This `AGENTS.md`
3. `ROADMAP.md`
4. `docs/standards/gui-shell-extended-standard.md`
5. `specs/*.schema.json`
6. Existing tests and validation scripts
7. Existing implementation patterns

If conflict exists, choose the stricter rule that preserves Shell Core authority boundaries, schema integrity, conformance coverage, and operator safety.

## 4. Required Work Order

Unless the owner explicitly instructs otherwise, work in this order:

1. Read `docs/standards/gui-shell-extended-standard.md`
2. Read relevant schemas under `specs/`
3. Preserve Shell Core / UI / Adapter / Rust helper boundaries
4. Add or update schemas before implementation when contracts change
5. Add or update conformance tests before product UI
6. Implement minimal bounded code
7. Run validation
8. Report exact results

Do not optimize a local task in a way that makes later phases less safe, less inspectable, or harder to validate.

## 5. Architecture Constraints

- UI framework: Flutter
- Native helper: Rust
- Contracts: JSON Schema
- Reference runtime: BLUE-TANUKI via adapter only
- Shell Core must remain framework-independent
- Adapter contracts must remain runtime-neutral
- Flutter must remain a replaceable UI layer
- BLUE-TANUKI implementation must not be modified for GUI Shell convenience unless the owner explicitly requests it

## 6. Boundary Semantics

### Shell Core

Shell Core owns:

- runtime registry
- permission ledger
- approval queue
- audit store
- recovery catalog
- update policy
- content exposure enforcement
- adapter conformance enforcement

Shell Core must not:

- import Flutter
- contain BLUE-TANUKI-specific logic
- trust adapter metadata
- use memory/cache/previous state as authority by itself
- silently broaden permission

### UI Layer

Flutter may own:

- rendering
- operator input
- navigation
- local UI state
- theme
- localization
- accessibility

Flutter must not own:

- authority decisions
- permission semantics
- approval semantics
- audit semantics
- recovery classification
- content visibility rules
- runtime trust rules

### Adapter Layer

Adapters may:

- normalize runtime state
- expose runtime health
- expose runtime diagnostics
- translate runtime events into GUI Shell schemas

Adapters must not:

- grant permission through metadata
- create authority context not granted by runtime
- display raw payloads beyond allowed visibility
- edit sealed, hidden, sacred, or authority fields
- bypass approval state
- bypass audit creation

### Rust Helper

Rust helper may perform bounded native diagnostics and operations.

Rust helper must not:

- become a hidden authority path
- silently introduce filesystem, process, network, credential, IPC, or update access
- execute sensitive actions without capability / permission / approval / audit / recovery mapping
- return unstructured sensitive data

## 7. Forbidden Patterns

Do not:

- put authority decisions in UI widgets
- let adapter metadata grant permissions
- let memory, local cache, or previous state grant authority by itself
- display full content unless `content_visibility=full`
- edit authority, sealed, hidden, or sacred fields in approval payloads
- introduce hidden network, filesystem, process, credential, IPC, or update access
- silently broaden runtime permissions
- add BLUE-TANUKI-specific logic to Shell Core
- place core contracts inside Flutter-specific code
- claim release readiness without validation evidence
- treat first-run success as product completion
- create speculative features outside the roadmap
- perform broad refactors unless required by the task

## 8. Required Audit Mapping

Every sensitive action must map to:

- Capability
- Permission
- Approval state
- AuditEvent
- RecoveryAction on failure

Sensitive actions include:

- filesystem access
- process execution/control
- network access
- credential access
- IPC
- update verification
- runtime adapter actions
- approval payload edits
- audit export/inspection
- recovery execution
- installer state changes
- device pairing

## 9. Content Exposure Rules

Allowed content visibility values:

```text
none
hash_only
summary
redacted
full
```

Rules:

- `none`: do not display raw content
- `hash_only`: display only payload hash
- `summary`: display only approved summary
- `redacted`: display only redacted projection
- `full`: full content may be displayed

Only `full` permits full payload display.

## 10. Approval Edit Rules

Approval editing must be field-scoped.

Do not allow editing of:

- authority fields
- sealed fields
- hidden fields
- sacred domain fields
- runtime identity
- permission identity
- audit identity
- payload hash directly

After any allowed edit:

- rehash payload
- revalidate payload
- mark approval as requiring validation when needed
- emit audit event

## 11. Git Operation Policy

This repository uses a direct-main owner workflow.

Every completed work block must be committed and pushed. Do not leave completed repository changes only in the local working tree unless the owner explicitly says not to commit or not to push.

Default workflow:

1. Work on `main`
2. Do not create feature branches or pull requests unless the owner explicitly asks
3. Before committing a completed work block on `main`, rotate the two-generation backup pair:
   - If `codex/backup-main` exists, force-update `codex/backup-main-prev` to `codex/backup-main`
   - Force-update `codex/backup-main` to current pre-commit `main`
4. Push backup branches when credentials allow
5. Commit the completed work block directly on `main`
6. Push `main` immediately after the commit
7. Verify `git status --short --branch` is clean and aligned with `origin/main`
8. If backup, commit, or push fails, report the exact failed command and reason

Backup branches:

```text
codex/backup-main
codex/backup-main-prev
```

Do not create additional backup generations.

Do not stage:

- secrets
- local runtime state
- Flutter build output
- Rust target output
- installer artifacts
- local caches
- generated logs unless explicitly requested

## 12. Required Validation Before Commit

Run at minimum:

```bash
python tooling/schema_check/check_schemas.py
python tooling/conformance_tests/run_conformance_skeleton.py
```

If `python` is unavailable:

```bash
python3 tooling/schema_check/check_schemas.py
python3 tooling/conformance_tests/run_conformance_skeleton.py
```

If Rust is installed and Rust helper is touched:

```bash
cd native/rust_helper && cargo test
```

If Flutter is installed and Flutter app is touched:

```bash
cd apps/desktop_flutter && flutter analyze
cd apps/mobile_flutter && flutter analyze
```

If validation cannot run, report why.

Never claim validation passed unless it actually passed.

## 13. Completion Report Format

Every completed change report must include:

1. Summary
2. Changed files
3. Risk classification
4. Validation results
5. Remaining risks
6. Commit hash, or `not committed`

Validation results must explicitly say which commands passed, failed, or were not run.

## 14. Documentation Language

Primary human-facing documentation language is Japanese.

English is allowed for:

- code comments where conventional
- schema identifiers
- protocol terms
- command names
- package metadata
- concise agent instruction text

Preserve established terms:

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

## 15. Product Stance

GUI Shell may make operation comfortable.

GUI Shell must not hide authority.

The UI is a surface, not the system authority.

Schemas and conformance are the contract gate.

Do not weaken approval, audit, visibility, or recovery requirements to improve comfort.

Do not use local owner operation as an excuse to reduce robustness.

Do not treat product UI completion as contract completion.
