# Release Checklist

In this repository, "release" means completed product release. Skeleton, preview, alpha, beta, scaffold, and contract-preview states are not release states.

No completed product release may be claimed if any `release_blocker` remains. GUI-Shell v1.0 desktop release scope is Linux, Windows, and macOS.

## Release Blockers

- item: cargo test gate for in-scope Rust helper
  classification: required_for_v1
  reason: Rust helper validation is required for completed desktop-first v1.0 release. Current run on 2026-05-25 passed.
  required_action: Pass `cd native/rust_helper && cargo test` on the release candidate.
  blocks_release: no

- item: desktop flutter analyze gate
  classification: required_for_v1
  reason: Desktop Flutter analyze is required for completed desktop-first v1.0 release. Current run on 2026-05-25 passed after `unzip` became available.
  required_action: Pass `cd apps/desktop_flutter && flutter analyze` on the release candidate.
  blocks_release: no

- item: Linux desktop build dependencies gate
  classification: required_for_v1
  reason: Rust/Cargo, Flutter, `unzip`, and Linux desktop build dependencies are resolved. `flutter doctor -v` reports clang 21.1.8, cmake 4.2.3, ninja 1.13.2, and pkg-config 2.5.1.
  required_action: Keep `$HOME/.cargo/bin` and `$HOME/dev/flutter/bin` on PATH and keep Linux desktop build dependencies installed for release candidates.
  blocks_release: no

- item: Linux desktop project configuration gate
  classification: required_for_v1
  reason: Linux desktop project support is configured and `cd apps/desktop_flutter && flutter build linux` passed on 2026-05-25, producing `build/linux/x64/release/bundle/gui_shell_desktop`.
  required_action: Keep Linux desktop project files and pass `flutter build linux` on the release candidate.
  blocks_release: no

- item: Linux desktop launch smoke gate
  classification: required_for_v1
  reason: `./build/linux/x64/release/bundle/gui_shell_desktop` launched successfully under WSLg on 2026-05-25; the first window opened with Dashboard, NavigationRail, Runtime Status, and Invariant Status visible.
  required_action: Keep Linux desktop launch smoke passing on release candidates.
  blocks_release: no

- item: WSLg libEGL/MESA graphics warnings
  classification: known_limitation
  reason: WSLg emitted libEGL/MESA warnings during Linux desktop launch, but rendering and first-window stability did not fail.
  required_action: Keep documented in release-facing docs and reclassify as `release_blocker` if rendering or stability fails.
  blocks_release: no

- item: Windows desktop project support not generated
  classification: release_blocker
  reason: `apps/desktop_flutter/windows` is missing.
  required_action: Generate Windows Flutter desktop project support and commit bounded project files.
  blocks_release: yes

- item: Windows Flutter toolchain not verified
  classification: release_blocker
  reason: Windows Flutter desktop toolchain has not been verified on a Windows host.
  required_action: Run Windows Flutter doctor/analyze/build validation on Windows.
  blocks_release: yes

- item: Windows desktop build smoke not passed
  classification: release_blocker
  reason: Windows build smoke has not passed.
  required_action: Pass `flutter build windows` on a Windows release-candidate host.
  blocks_release: yes

- item: Windows desktop launch smoke not passed
  classification: release_blocker
  reason: Windows launch smoke evidence has not been recorded.
  required_action: Launch the Windows desktop artifact and record first-window evidence.
  blocks_release: yes

- item: Windows installer first-run smoke not passed
  classification: release_blocker
  reason: Windows installer and first-run smoke have not passed.
  required_action: Pass Windows installer/first-run smoke validation.
  blocks_release: yes

- item: macOS desktop project support not generated
  classification: release_blocker
  reason: `apps/desktop_flutter/macos` is missing.
  required_action: Generate macOS Flutter desktop project support and commit bounded project files.
  blocks_release: yes

- item: macOS Flutter toolchain not verified
  classification: release_blocker
  reason: macOS Flutter desktop toolchain has not been verified on a macOS host.
  required_action: Run macOS Flutter doctor/analyze/build validation on macOS.
  blocks_release: yes

- item: macOS desktop build smoke not passed
  classification: release_blocker
  reason: macOS build smoke has not passed.
  required_action: Pass `flutter build macos` on a macOS release-candidate host.
  blocks_release: yes

- item: macOS desktop launch smoke not passed
  classification: release_blocker
  reason: macOS launch smoke evidence has not been recorded.
  required_action: Launch the macOS desktop artifact and record first-window evidence.
  blocks_release: yes

- item: macOS installer first-run smoke not passed
  classification: release_blocker
  reason: macOS installer and first-run smoke have not passed.
  required_action: Pass macOS installer/first-run smoke validation.
  blocks_release: yes

- item: OS-specific Setup Doctor diagnostics not passed
  classification: release_blocker
  reason: Setup Doctor real diagnostics have not passed for every v1.0 desktop target.
  required_action: Pass Linux, Windows, and macOS Setup Doctor diagnostics smoke.
  blocks_release: yes

- item: validate_all.py strict release mode not passed
  classification: release_blocker
  reason: Current-host Linux validation may pass, but all-desktop strict release mode must not report release blockers before completed product release.
  required_action: Pass `python3 tooling/validate_all.py --strict-release --desktop-platform=all` and the normal aggregate validation used by this repository.
  blocks_release: yes

- item: installer first-run smoke not passed
  classification: release_blocker
  required_action: Add and pass installer first-run smoke validation.
  blocks_release: yes

- item: Setup Doctor real diagnostics not passed
  classification: release_blocker
  required_action: Run Setup Doctor from installed app path and pass diagnostics.
  blocks_release: yes

- item: Shell Core persistence smoke not passed
  classification: release_blocker
  required_action: Pass save/load snapshot and persistence smoke validation.
  blocks_release: yes

- item: audit chain verification not passed
  classification: release_blocker
  required_action: Pass audit chain verification and tamper detection smoke validation.
  blocks_release: yes

- item: approval edit to rehash to revalidation smoke not passed
  classification: release_blocker
  required_action: Pass approval edit workflow smoke validation.
  blocks_release: yes

- item: content_visibility UI enforcement not passed
  classification: release_blocker
  required_action: Pass UI projection enforcement smoke validation.
  blocks_release: yes

- item: Runtime Catalog validation not passed
  classification: release_blocker
  required_action: Pass Runtime Catalog validation and use smoke.
  blocks_release: yes

- item: Agent Runtime Contract validation not passed
  classification: release_blocker
  required_action: Pass Agent Runtime Contract validation and mock/reference smoke.
  blocks_release: yes

- item: reference runtime smoke not passed
  classification: release_blocker
  required_action: Add and pass reference runtime smoke validation.
  blocks_release: yes

- item: reference agent smoke not passed
  classification: release_blocker
  required_action: Add and pass reference agent smoke validation.
  blocks_release: yes

- item: README / CLAIM / RELEASE_CHECKLIST not aligned with actual release state
  classification: release_blocker
  required_action: Pass release gate document scan.
  blocks_release: yes

- item: owner GO missing
  classification: release_blocker
  required_action: Obtain explicit owner GO.
  blocks_release: yes

## Post-v1 Scope Defaults

- item: mobile full release
  classification: post_v1_scope
  reason: v1.0 is desktop-first unless owner explicitly includes mobile in release scope.
  blocks_release: no

- item: multi-user mode
  classification: post_v1_scope
  reason: v1.0 is single-user.
  blocks_release: no

- item: cloud sync
  classification: post_v1_scope
  reason: v1.0 is local-first.
  blocks_release: no

- item: marketplace
  classification: post_v1_scope
  reason: v1.0 excludes runtime marketplace.
  blocks_release: no

- item: enterprise admin
  classification: post_v1_scope
  reason: v1.0 is not enterprise admin scope.
  blocks_release: no

- item: full live Codex / Claude Code / Copilot / Cursor / Devin / OpenHands integrations
  classification: post_v1_scope
  reason: v1.0 requires generic Agent Runtime contract and mock/reference agent only.
  blocks_release: no

- item: BLUE-TANUKI product completion
  classification: post_v1_scope
  reason: BLUE-TANUKI is a consumer/reference runtime, not a GUI-Shell release gate.
  blocks_release: no

## Known Limitation Rule

Known limitations are allowed only if:

- classification: known_limitation
  reason: limitation does not violate v1.0 release criteria
  required_action: Document in README.md and CLAIM.md
  blocks_release: no

- classification: known_limitation
  reason: limitation does not hide safety, authority, audit, recovery, installer, or validation failures
  required_action: Keep release-facing documentation explicit
  blocks_release: no
