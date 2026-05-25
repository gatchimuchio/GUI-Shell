# Installer Status

Current phase: Phase B owner-use operational hardening. Installer work is not being treated as paid/product QC yet, but completed product release still requires measured Windows installed-path evidence.

## Implemented Areas

- item: `installer/setup_doctor.py`
  classification: required_for_v1
  status: structured status checks present

- item: dependency recovery instructions
  classification: required_for_v1
  status: present

- item: `installer_grants_authority=false`
  classification: required_for_v1
  status: present

- item: `installer_silently_approves_permissions=false`
  classification: required_for_v1
  status: present

- item: installer boundary documentation
  classification: required_for_v1
  status: present

## Release Blockers

- item: Windows installed-path first-run evidence missing
  classification: release_blocker
  reason: Windows-first completed product release requires measured installed-path first-run evidence.
  required_action: Run the hardened Windows installed smoke collector with real Setup Doctor JSON, visible-surface evidence, config path, and audit dir probe inputs.
  blocks_release: yes

- item: Windows Setup Doctor installed-path evidence missing
  classification: release_blocker
  reason: Setup Doctor must be proven from the installed Windows app path before completed product release.
  required_action: Record non-synthetic installed-path Setup Doctor diagnostics and pass `python tooling/windows_release_evidence.py`.
  blocks_release: yes

## Known Limitations

- item: macOS packaged installer not verified
  classification: known_limitation
  reason: GUI-Shell v1.0 is Windows-first and no macOS validation environment is available.
  required_action: Validate on macOS before claiming macOS installer support.
  blocks_release: no

- item: Linux packaged installer not release-gated
  classification: known_limitation
  reason: Linux is currently a development/verification slice, not the Windows-first product release target.
  required_action: Keep Linux build/smoke useful for development; add Linux installer validation before claiming Linux product support.
  blocks_release: no

## Later QC

- item: installer recovery instructions missing for packaged failures
  classification: post_v1_scope
  reason: paid/product QC requires fuller installer recovery and rollback coverage than Phase B owner-use operation.
  required_action: Add installer failure recovery catalog, rollback notes, and long-run packaging smoke before paid/product release.
  blocks_release: no
