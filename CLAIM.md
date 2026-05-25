# GUI Shell Claim Boundary

## Current Status

GUI-Shell is not yet a completed product release.

Current claim: Desktop-first AI Runtime / Agent Operation Shell product-completion skeleton.

## Current Completed Areas

- item: schema and conformance skeleton
  classification: required_for_v1
  status: passed in development validation

- item: Shell Core hardening skeleton
  classification: required_for_v1
  status: contract-level implementation present

- item: Runtime Catalog skeleton
  classification: required_for_v1
  status: schema, fixtures, package, and conformance present

- item: Agent Runtime skeleton
  classification: required_for_v1
  status: schema, fixtures, package, and conformance present

- item: Rust helper boundary skeleton
  classification: required_for_v1
  status: implementation present; `cd native/rust_helper && cargo test` passed on 2026-05-25

- item: Desktop Flutter skeleton
  classification: required_for_v1
  status: implementation present; `cd apps/desktop_flutter && flutter analyze` passed on 2026-05-25

- item: Setup Doctor skeleton
  classification: required_for_v1
  status: implementation present

- item: release-hardening documents
  classification: required_for_v1
  status: implementation present

## Current Release Blockers

- item: Desktop launch/build toolchain validation not passed
  classification: release_blocker
  reason: v1.0 is desktop-first, and `flutter doctor` reports missing Linux desktop build dependencies: clang++, CMake, ninja, and pkg-config.
  required_action: Install Linux desktop build dependencies, then pass desktop launch/build smoke validation.
  blocks_release: yes

- item: Desktop app launch smoke not passed
  classification: release_blocker
  reason: v1.0 is a completed desktop product release.
  required_action: Add and pass desktop launch smoke validation.
  blocks_release: yes

- item: Installer first-run smoke not passed
  classification: release_blocker
  reason: installer and first-run are in v1.0 scope.
  required_action: Add and pass installer first-run smoke validation.
  blocks_release: yes

- item: Shell Core persistence smoke not passed
  classification: release_blocker
  reason: persistence is in v1.0 scope.
  required_action: Add and pass persistence smoke validation.
  blocks_release: yes

- item: Audit chain verification smoke not passed
  classification: release_blocker
  reason: audit chain verification is in v1.0 scope.
  required_action: Add and pass audit chain smoke validation.
  blocks_release: yes

- item: Runtime Catalog live/use smoke not passed
  classification: release_blocker
  reason: Runtime Catalog is in v1.0 scope.
  required_action: Add and pass Runtime Catalog smoke validation.
  blocks_release: yes

- item: Agent Runtime mock/reference smoke not passed
  classification: release_blocker
  reason: Agent Runtime is in v1.0 scope.
  required_action: Add and pass mock/reference agent smoke validation.
  blocks_release: yes

- item: Strict release validation not passed
  classification: release_blocker
  reason: completed desktop-first product release requires strict release validation.
  required_action: Pass `python3 tooling/validate_all.py --strict-release`.
  blocks_release: yes

- item: Owner GO missing
  classification: release_blocker
  reason: release claim promotion requires owner approval.
  required_action: Obtain explicit owner GO.
  blocks_release: yes

## Post-v1 Scope

- item: Mobile full release
  classification: post_v1_scope
  reason: v1.0 scope is desktop-first unless owner explicitly includes mobile.
  required_action: Complete after v1.0 or update scope by owner instruction.
  blocks_release: no

- item: Multi-user mode
  classification: post_v1_scope
  reason: v1.0 is single-user.
  required_action: Defer until post-v1 planning.
  blocks_release: no

- item: Cloud service
  classification: post_v1_scope
  reason: v1.0 is local-first.
  required_action: Defer until post-v1 planning.
  blocks_release: no

- item: Marketplace
  classification: post_v1_scope
  reason: v1.0 does not include runtime marketplace distribution.
  required_action: Defer until post-v1 planning.
  blocks_release: no

- item: Enterprise admin
  classification: post_v1_scope
  reason: v1.0 is single-user desktop.
  required_action: Defer until post-v1 planning.
  blocks_release: no

- item: Full live third-party agent integrations
  classification: post_v1_scope
  reason: v1.0 requires generic Agent Runtime contract and mock/reference agent, not all live adapters.
  required_action: Add after v1.0 as adapter work.
  blocks_release: no

- item: BLUE-TANUKI product completion
  classification: post_v1_scope
  reason: BLUE-TANUKI is a consumer/reference runtime, not a GUI-Shell release gate.
  required_action: Complete as consumer integration after GUI-Shell v1.0 gate.
  blocks_release: no

## Known Limitations

- item: local single-user only
  classification: known_limitation
  reason: v1.0 product scope is desktop-first, single-user, local-first.
  required_action: Keep README, CLAIM, and RELEASE_CHECKLIST aligned.
  blocks_release: no
