# Desktop Platform Matrix

Status date: 2026-05-25

GUI-Shell v1.0 is Windows-first. Windows is the primary product target, Linux is the validated development/verification slice, and macOS is an unverified planned portability target. Current-host Linux validation can pass on Linux, but it is not final product proof by itself.

GUI-Shell v1.0 does not claim verified macOS support. macOS support must not be advertised as supported, ready, or complete until validated on a macOS host.

| Platform | Priority | Project support | Required toolchain | Validation command | Build smoke | Launch smoke evidence | Installer / first-run status | Release classification |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Windows | Primary product target | generated | Flutter Windows desktop toolchain on Windows host, including Visual Studio Build Tools; Windows-side PATH currently lacks Flutter, rustc, and cargo | `cd apps/desktop_flutter && flutter analyze && flutter test && flutter build windows` | not_passed: release_blocker; WSL attempt failed because Windows build requires Windows host | not_recorded: release_blocker | not_passed: release_blocker | release_blocker |
| macOS | Planned portability target | unverified_planned | Flutter macOS desktop toolchain on macOS host, including Xcode | `cd apps/desktop_flutter && flutter analyze && flutter build macos` before claiming support | unverified_planned: known_limitation | unverified_planned: known_limitation | unverified_planned: known_limitation | known_limitation; blocks_release: no |
| Linux | Development/verification slice | generated | Flutter Linux desktop toolchain: clang, cmake, ninja, pkg-config | `cd apps/desktop_flutter && flutter analyze && flutter test && flutter build linux` | passed on 2026-05-25 | passed under WSLg; first window opened; Dashboard, NavigationRail, Runtime Status, and Invariant Status visible | not_primary_release_gate: known_limitation | required_for_v1 development slice; current build and launch smoke blocks_release: no |

## Release Gate

- item: Linux desktop build smoke
  classification: required_for_v1
  reason: `cd apps/desktop_flutter && flutter build linux` passed and produced `build/linux/x64/release/bundle/gui_shell_desktop`.
  required_action: Keep Linux build smoke passing as a development/verification slice.
  blocks_release: no

- item: Linux desktop launch smoke
  classification: required_for_v1
  reason: `./build/linux/x64/release/bundle/gui_shell_desktop` launched under WSLg and first-window evidence was recorded; Linux is not final Windows-first product proof by itself.
  required_action: Keep Linux launch smoke passing while completing Windows product gates.
  blocks_release: no

- item: Windows desktop validation
  classification: release_blocker
  reason: Windows project support exists, but Windows toolchain verification, analyze, test, build smoke, launch smoke, Setup Doctor smoke, installer smoke, and first-run smoke have not passed on a native Windows host.
  required_action: Install/verify Windows toolchains and validate Windows release path on a native Windows host.
  blocks_release: yes

- item: macOS planned portability target
  classification: known_limitation
  reason: no macOS validation environment is currently available, so GUI-Shell v1.0 does not claim verified macOS support.
  required_action: Validate on a macOS host before claiming macOS support.
  blocks_release: no

- item: Windows Setup Doctor diagnostics
  classification: release_blocker
  reason: Setup Doctor diagnostics smoke has not passed on the primary Windows product target.
  required_action: Pass Windows Setup Doctor diagnostics smoke.
  blocks_release: yes
