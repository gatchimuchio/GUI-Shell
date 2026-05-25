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
