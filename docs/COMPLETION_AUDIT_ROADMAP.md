# Completion Audit Roadmap

Status date: 2026-05-25

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
  evidence: `packages/shell_core/normalization.py` preserves raw payloads, normalizes keys, strips authority aliases, detects authority-like values, quarantines ambiguous authority-bearing payloads, and emits normalization audit event metadata.
  blocks_release: no

- item: conformance coverage
  classification: required_for_v1
  status: implemented
  evidence: conformance covers Unicode/case/zero-width/camelCase/alias/value-only authority attempts and intentional invariant import violation detection.
  blocks_release: no

## Remaining Release Blockers

- item: Windows installer and first-run smoke
  classification: release_blocker
  reason: installed app path first-run evidence has not passed.
  required_action: implement and pass Windows installer/first-run validation.
  blocks_release: yes

- item: Windows Setup Doctor real diagnostics smoke
  classification: release_blocker
  reason: Setup Doctor has not passed from the installed Windows app path.
  required_action: connect desktop UI and installed app path smoke to real Setup Doctor diagnostics.
  blocks_release: yes

- item: Shell Core persistence smoke
  classification: release_blocker
  reason: save/load crash recovery and state persistence smoke remains unpassed as a release gate.
  required_action: pass integrated persistence smoke, not only helper-level checks.
  blocks_release: yes

- item: audit chain verification smoke
  classification: release_blocker
  reason: release-gate audit chain and tamper-detection smoke remains unpassed.
  required_action: pass integrated append-only audit and tamper-detection smoke.
  blocks_release: yes

- item: content visibility UI smoke
  classification: release_blocker
  reason: Flutter UI enforcement smoke for content visibility remains unpassed.
  required_action: add widget/integration evidence that full payload is hidden unless `content_visibility=full`.
  blocks_release: yes

- item: Runtime Catalog live/use smoke
  classification: release_blocker
  reason: Runtime Catalog use against reference runtime remains unpassed.
  required_action: pass Runtime Catalog and reference runtime smoke.
  blocks_release: yes

- item: reference Runtime/Agent smoke
  classification: release_blocker
  reason: reference Runtime/Agent smoke remains unpassed.
  required_action: pass mock/reference runtime and agent smoke.
  blocks_release: yes

- item: Owner GO
  classification: release_blocker
  reason: completed product release requires explicit owner approval.
  required_action: obtain owner GO only after all release blockers pass.
  blocks_release: yes

## Next Execution Order

1. Complete Shell Core persistence, append-only audit, recovery linkage, and approval lifecycle smokes.
2. Connect desktop Setup Doctor UI to real diagnostics and validate from installed app path.
3. Implement Windows installer/first-run smoke and artifact/hash evidence.
4. Add GitHub Actions CI for schema, conformance, release gate, Rust, Flutter, Windows build, and artifact validation.
5. Run `python3 tooling/validate_all.py --strict-release --desktop-platform=windows`.

## Release Rule

Do not say release-ready until:

- strict Windows release gate passes,
- installer/first-run smoke passes,
- Setup Doctor real diagnostics smoke passes,
- persistence/audit/approval/content visibility/runtime/agent smokes pass,
- README/CLAIM/release docs match evidence,
- owner GO is explicit.
