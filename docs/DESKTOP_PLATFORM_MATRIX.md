# Desktop Platform Matrix

Status date: 2026-05-25

GUI-Shell v1.0 is Windows-first. Windows is the primary product target, macOS is the secondary portability target, and Linux is the validated development/verification slice. Current-host Linux validation can pass on Linux, but it is not final product proof by itself.

| Platform | Priority | Project support | Required toolchain | Validation command | Build smoke | Launch smoke evidence | Installer / first-run status | Release classification |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Windows | Primary product target | not_generated: release_blocker | Flutter Windows desktop toolchain on Windows host, including Visual Studio Build Tools | `cd apps/desktop_flutter && flutter analyze && flutter test && flutter build windows` | not_passed: release_blocker | not_recorded: release_blocker | not_passed: release_blocker | release_blocker |
| macOS | Secondary portability target | not_generated: release_blocker | Flutter macOS desktop toolchain on macOS host, including Xcode | `cd apps/desktop_flutter && flutter analyze && flutter build macos` | not_passed: release_blocker | not_recorded: release_blocker | not_passed: release_blocker; packaging/notarization plan not_documented: release_blocker | release_blocker |
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
  reason: Windows project support, toolchain verification, analyze, test, build smoke, launch smoke, Setup Doctor smoke, installer smoke, and first-run smoke have not passed.
  required_action: Generate Windows support if missing and validate Windows release path on a Windows host.
  blocks_release: yes

- item: macOS desktop validation
  classification: release_blocker
  reason: macOS project support, toolchain verification, build smoke, launch smoke, packaging/notarization plan, installer smoke, and first-run smoke have not passed.
  required_action: Generate macOS support if missing and validate macOS release path on a macOS host.
  blocks_release: yes

- item: Windows Setup Doctor diagnostics
  classification: release_blocker
  reason: Setup Doctor diagnostics smoke has not passed on the primary Windows product target.
  required_action: Pass Windows Setup Doctor diagnostics smoke.
  blocks_release: yes
