# Product Completion Plan

GUI-Shell v1.0 means completed Windows-first PC desktop product release.

- item: skeleton, preview, alpha, beta, and scaffold states
  classification: release_blocker
  reason: these states are not completed product release states.
  blocks_release: yes

## Required For v1

Platform priority:

- Primary: Windows
- Secondary: macOS
- Development/verification slice: Linux

- item: Desktop app
  classification: required_for_v1
  reason: v1.0 desktop release is Windows-first, with macOS portability and Linux development verification.
  blocks_release: yes

- item: Linux desktop build and launch smoke
  classification: required_for_v1
  reason: current Linux build smoke and launch smoke passed on 2026-05-25 as development/verification proof, not final product proof by itself.
  blocks_release: no

- item: Windows desktop project support, analyze, test, build, launch, Setup Doctor, installer, and first-run smoke
  classification: release_blocker
  reason: Windows is the primary product target, and Windows project support, Flutter toolchain, analyze, test, build, launch, Setup Doctor, installer, and first-run smoke have not passed.
  required_action: Generate Windows support if missing and pass all Windows target validation.
  blocks_release: yes

- item: macOS desktop project support, build, launch, packaging/notarization, installer, and first-run smoke
  classification: release_blocker
  reason: macOS is the secondary portability target, and macOS project support, toolchain, build, launch, packaging/notarization plan, installer, and first-run smoke have not passed.
  required_action: Generate macOS support if missing and pass macOS target validation.
  blocks_release: yes

- item: Windows Setup Doctor diagnostics
  classification: release_blocker
  reason: real Setup Doctor diagnostics have not passed on the primary Windows target.
  required_action: Pass Windows Setup Doctor diagnostics smoke.
  blocks_release: yes

- item: Single-user local-first mode
  classification: required_for_v1
  blocks_release: yes

- item: Installer first-run flow
  classification: required_for_v1
  blocks_release: yes

- item: Setup Doctor
  classification: required_for_v1
  blocks_release: yes

- item: Runtime Catalog
  classification: required_for_v1
  blocks_release: yes

- item: Agent Runtime Contract
  classification: required_for_v1
  blocks_release: yes

- item: Shell Core persistence
  classification: required_for_v1
  blocks_release: yes

- item: Permission / Approval / Audit / Recovery
  classification: required_for_v1
  blocks_release: yes

- item: Audit chain verification
  classification: required_for_v1
  blocks_release: yes

- item: Rust helper validation
  classification: required_for_v1
  blocks_release: yes

- item: Desktop Flutter validation
  classification: required_for_v1
  blocks_release: yes

- item: Mock/reference runtime
  classification: required_for_v1
  blocks_release: yes

- item: Mock/reference agent
  classification: required_for_v1
  blocks_release: yes

## Post-v1 Scope

- item: completed mobile companion
  classification: post_v1_scope
  reason: v1.0 is Windows-first PC desktop unless owner changes scope.
  blocks_release: no

- item: multi-user
  classification: post_v1_scope
  reason: v1.0 is single-user.
  blocks_release: no

- item: cloud service
  classification: post_v1_scope
  reason: v1.0 is local-first.
  blocks_release: no

- item: runtime marketplace
  classification: post_v1_scope
  reason: v1.0 excludes marketplace distribution.
  blocks_release: no

- item: BLUE-TANUKI product completion
  classification: post_v1_scope
  reason: BLUE-TANUKI is a consumer/reference runtime.
  blocks_release: no

- item: all live coding-agent adapters
  classification: post_v1_scope
  reason: v1.0 requires generic contract and mock/reference agent.
  blocks_release: no

- item: enterprise admin
  classification: post_v1_scope
  reason: v1.0 is single-user desktop.
  blocks_release: no

## Known Limitations

- item: local single-user mode
  classification: known_limitation
  reason: deliberate v1.0 product scope.
  blocks_release: no

- item: mock/reference runtime and agent as included references
  classification: known_limitation
  reason: live third-party integrations are outside v1.0 unless explicitly included.
  blocks_release: no
