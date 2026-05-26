# Phase Strategy

GUI-Shell uses phase-based readiness language so owner-use progress is not confused with completed product release readiness.

## Current Phase

- phase: A
  name: personal Windows trial operation
  status: complete
  evidence: Windows desktop build and native launch smoke passed; Dashboard, NavigationRail, Runtime Status, and Invariant Status were visible.

- phase: B
  name: owner-use operational hardening
  status: active
  goal: make GUI-Shell useful for daily personal operation while preserving authority, audit, approval, recovery, and evidence boundaries.
  current_surfaces: Dashboard phase status, persistent status bar, Problems Panel, Evidence Center, and Recovery Playbook are available as display-only owner-operation surfaces.

## Phase B Roadmap

- item: B-1 owner operation console
  classification: required_for_v1
  status: complete
  evidence: Dashboard phase status, persistent status bar, Problems Panel, Evidence Center, Recovery Playbook, and release-not-claimed UI are implemented.
  blocks_release: no

- item: B-2 local snapshot / local runtime wiring
  classification: required_for_v1
  status: complete
  evidence: `ShellCoreClient.local()` loads `GUI_SHELL_SNAPSHOT_JSON`, `%LOCALAPPDATA%\GUI-Shell\shell_snapshot.json`, or `.gui_shell/shell_snapshot.json`; parse/missing failures fall back safely without release claim.
  blocks_release: no

- item: B-3 owner launch flow
  classification: required_for_v1
  status: complete
  evidence: `scripts/launch_owner_desktop.sh` and `scripts/launch_owner_desktop.ps1` generate `.gui_shell/shell_snapshot.json` and launch Flutter desktop without strict release validation or release evidence generation.
  blocks_release: no

- item: B-4 Problems to Recovery loop
  classification: required_for_v1
  status: next
  reason: owner-use operation needs clearer problem-to-recovery mapping, copyable commands/paths where safe, and separate owner-use blockers from completed product release blockers.
  required_action: connect Problems rows to Recovery Playbook rows with `safe_to_ignore_for_phase_b`, `blocks_owner_use`, and `blocks_completed_product_release` language.
  blocks_release: no

- item: B-5 Trust / Authority / Runtime Map
  classification: required_for_v1
  status: next
  reason: Phase B should restore the control-plane visibility surfaces after local snapshot wiring.
  required_action: expose Trust Center and Authority Map as owner-use display surfaces for Runtime -> Capability -> Permission -> Approval -> Audit -> Recovery.
  blocks_release: no

- item: B-6 owner-use completion gate
  classification: required_for_v1
  status: later
  reason: owner-use completion requires easy launch, visible status/problems/recovery, local snapshot/fallback behavior, and no release-ready claim.
  required_action: document Phase B owner-use complete after B-4 and B-5 pass validation and owner confirms usability.
  blocks_release: no

## Later Phases

- phase: C
  name: OSS claim hygiene
  status: next
  goal: keep README, CLAIM, release checklist, audit, installer, security, and strategy docs aligned so external readers cannot mistake Phase B for release readiness.

- phase: D
  name: measured Windows release evidence
  status: later
  goal: collect native Windows installed-path evidence and pass the hardened Windows evidence validator.

- phase: E
  name: OSS v1.0 release candidate
  status: later
  goal: pass strict Windows release validation, preserve known limitations, and wait for owner GO.

- phase: F
  name: paid/product QC
  status: later
  goal: complete support, rollback, long-run, legal, dependency, installer, and third-party-user quality gates.

## Release Rule

Do not claim completed product release until strict Windows release validation passes and owner GO is explicit.

Phase B may improve owner usability without weakening strict release gates.
