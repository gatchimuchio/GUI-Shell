# Completion Audit Roadmap

Status date: 2026-05-26

## Audit Conclusion

GUI-Shell is a strong Windows-first v1.0 skeleton for a control-plane Runtime Operation Shell. It is not a completed product release.

The architecture remains valid:

- Shell Core owns authority.
- Flutter renders operator surfaces and must not own authority.
- Runtime and adapter boundaries remain separate.
- BLUE-TANUKI remains a consumer/reference runtime through adapter boundaries, not a GUI-Shell release dependency.
- Schema and conformance own the contract.

Release completion must not be claimed until strict Windows release validation passes and owner GO is explicit.

## Implemented From Audit

- item: measured invariant evaluator
  classification: required_for_v1
  status: implemented
  evidence: `packages/shell_core/invariant_evaluator.py` measures import boundaries, adapter metadata escalation, non-authority source grants, content projection, installer/setup authority, and mobile/device authority.
  blocks_release: no

- item: state snapshot invariant measurement
  classification: required_for_v1
  status: implemented
  evidence: `packages/shell_core/state_snapshot.py` now calls `InvariantEvaluator().evaluate()` instead of returning static invariant flags.
  blocks_release: no

- item: normalization firewall
  classification: required_for_v1
  status: implemented
  evidence: `packages/shell_core/normalization.py` preserves raw payloads, normalizes keys, strips authority aliases, detects authority-like values, quarantines ambiguous authority-bearing payloads, and emits normalization audit event metadata. PolicyEvaluator, AdapterLoader, RuntimeCatalog, and BLUE-TANUKI authority trace now use the shared normalization authority scanners instead of exact raw key matching.
  blocks_release: no

- item: metadata value-only authority policy
  classification: required_for_v1
  status: implemented
  evidence: adapter metadata with authority-like values after key stripping is rejected; PolicyEvaluator flags value-only adapter metadata authority attempts.
  blocks_release: no

- item: Flutter local Shell Core client
  classification: required_for_v1
  status: implemented
  evidence: `ShellCoreClient.local()` loads structured local snapshot JSON from `GUI_SHELL_SNAPSHOT_JSON`, `%LOCALAPPDATA%\GUI-Shell\shell_snapshot.json` on Windows, or `.gui_shell/shell_snapshot.json` for local development; `ShellCoreClient.mock()` remains separate for tests/demo.
  blocks_release: no

- item: GUI operation surfaces
  classification: required_for_v1
  status: implemented
  evidence: `docs/GUI_OPERATION_SURFACES.md` records Trust Center, Authority Map, Audit Timeline, Recovery Playbook, Adapter Catalog, Permission Diff, Settings UX, Problems Panel, Evidence Center, Command Palette, and Status Bar surfaces.
  blocks_release: no

- item: Shell snapshot generator
  classification: required_for_v1
  status: implemented
  evidence: `tooling/shell_snapshot.py` produces the structured local snapshot consumed by Flutter local mode, including trust, authority, catalog, problems, evidence, settings, audit, recovery, and Setup Doctor fields.
  blocks_release: no

- item: Evidence bundle export
  classification: required_for_v1
  status: implemented
  evidence: `tooling/evidence_bundle.py --check` validates a development evidence bundle with release blockers preserved and `release_ready=false`.
  blocks_release: no

- item: conformance coverage
  classification: required_for_v1
  status: implemented
  evidence: conformance covers Unicode/case/zero-width/camelCase/alias/value-only authority attempts and intentional invariant import violation detection.
  blocks_release: no

- item: Shell Core persistence, audit, approval, and recovery smoke
  classification: required_for_v1
  status: implemented
  evidence: `packages/shell_core/release_smoke.py` covers state snapshot save/load, append-only audit verification, audit tamper detection, approval edit rehash/revalidation, and recovery_id policy verification.
  blocks_release: no

- item: implementation first-run and Setup Doctor smoke
  classification: required_for_v1
  status: implemented
  evidence: `tooling/release_smoke.py` runs first-run config/audit initialization and structured Setup Doctor non-authority checks.
  blocks_release: no

- item: Runtime Catalog and Agent Runtime reference smoke
  classification: required_for_v1
  status: implemented
  evidence: `tooling/release_smoke.py` registers reference manifests through RuntimeCatalog and validates Agent Runtime workspace, secret path, permission mapping, and auditable diff behavior.
  blocks_release: no

- item: Windows installed-path evidence validator
  classification: required_for_v1
  status: implemented
  evidence: `tooling/windows_release_evidence.py` validates `release_evidence/windows_installed_smoke.json` for installed executable hash, installed-path first run, non-zero window handle, visible-surface evidence source, config JSON parsing, audit write/read/delete probe, and non-synthetic Setup Doctor non-authority diagnostics.
  blocks_release: no

## Remaining Release Blockers

- item: Windows installer and first-run smoke
  classification: release_blocker
  reason: installed app path first-run evidence is missing from `release_evidence/windows_installed_smoke.json`.
  required_action: run native Windows installed smoke collection and pass `python tooling\windows_release_evidence.py`.
  blocks_release: yes

- item: Windows Setup Doctor real diagnostics smoke
  classification: release_blocker
  reason: Setup Doctor has not passed from the installed Windows app path because evidence is missing.
  required_action: record installed-path Setup Doctor diagnostics and pass `python tooling\windows_release_evidence.py`.
  blocks_release: yes

- item: Owner GO
  classification: release_blocker
  reason: completed product release requires explicit owner approval.
  required_action: obtain owner GO only after all release blockers pass.
  blocks_release: yes

## Next Execution Order

1. Connect native Windows installed app path to real Setup Doctor diagnostics evidence; synthetic Setup Doctor payloads must fail validation.
2. Run native Windows installer/first-run smoke with measured window, visible-surface, config, and audit write/read/delete evidence.
3. Add installed executable smoke evidence to the release bundle.
4. Keep GitHub Actions CI covering schema, conformance, release smoke, release gate, Rust, Flutter, Windows build, and artifact validation.
5. Run `python3 tooling/validate_all.py --strict-release --desktop-platform=windows`.

## Release Rule

Do not say release-ready until:

- strict Windows release gate passes,
- installer/first-run smoke passes,
- Setup Doctor real diagnostics smoke passes,
- persistence/audit/approval/content visibility/runtime/agent smokes pass,
- README/CLAIM/release docs match evidence,
- owner GO is explicit.
