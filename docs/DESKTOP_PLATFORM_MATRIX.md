# Desktop Platform Matrix

Status date: 2026-05-25

GUI-Shell v1.0 completed product release scope is Linux, Windows, and macOS desktop. Current-host Linux validation can pass on Linux, but all-desktop release validation must fail until Windows and macOS evidence exists.

| Platform | Project support | Required toolchain | Validation command | Build smoke | Launch smoke evidence | Installer / first-run status | Release classification |
| --- | --- | --- | --- | --- | --- | --- | --- |
| Linux | generated | Flutter Linux desktop toolchain: clang, cmake, ninja, pkg-config | `cd apps/desktop_flutter && flutter analyze && flutter test && flutter build linux` | passed on 2026-05-25 | passed under WSLg; first window opened; Dashboard, NavigationRail, Runtime Status, and Invariant Status visible | not_passed: release_blocker until Linux installer/first-run smoke passes | required_for_v1; current build and launch smoke block_release: no |
| Windows | not_generated: release_blocker | Flutter Windows desktop toolchain on Windows host, including Visual Studio desktop build tools | `cd apps/desktop_flutter && flutter analyze && flutter build windows` | not_passed: release_blocker | not_recorded: release_blocker | not_passed: release_blocker | release_blocker |
| macOS | not_generated: release_blocker | Flutter macOS desktop toolchain on macOS host, including Xcode | `cd apps/desktop_flutter && flutter analyze && flutter build macos` | not_passed: release_blocker | not_recorded: release_blocker | not_passed: release_blocker | release_blocker |

## Release Gate

- item: Linux desktop build smoke
  classification: required_for_v1
  reason: `cd apps/desktop_flutter && flutter build linux` passed and produced `build/linux/x64/release/bundle/gui_shell_desktop`.
  required_action: Keep Linux build smoke passing on release candidates.
  blocks_release: no

- item: Linux desktop launch smoke
  classification: required_for_v1
  reason: `./build/linux/x64/release/bundle/gui_shell_desktop` launched under WSLg and first-window evidence was recorded.
  required_action: Keep Linux launch smoke passing on release candidates.
  blocks_release: no

- item: Windows desktop validation
  classification: release_blocker
  reason: Windows project support, toolchain verification, build smoke, launch smoke, installer smoke, and first-run smoke have not passed.
  required_action: Generate Windows support if missing and validate Windows release path on a Windows host.
  blocks_release: yes

- item: macOS desktop validation
  classification: release_blocker
  reason: macOS project support, toolchain verification, build smoke, launch smoke, installer smoke, and first-run smoke have not passed.
  required_action: Generate macOS support if missing and validate macOS release path on a macOS host.
  blocks_release: yes

- item: OS-specific Setup Doctor diagnostics
  classification: release_blocker
  reason: Setup Doctor diagnostics smoke has not passed per Linux, Windows, and macOS target.
  required_action: Pass OS-specific Setup Doctor diagnostics smoke.
  blocks_release: yes
