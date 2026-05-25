# Desktop Build Smoke

Status date: 2026-05-25

GUI Shell v1.0 is desktop-first. Mobile remains `post_v1_scope` unless the owner explicitly changes release scope.

## Smoke Levels

### Analyze Smoke

- command: `cd apps/desktop_flutter && flutter analyze`
- purpose: Dart/Flutter static analysis for the desktop Flutter UI layer
- current_status: passed
- classification: required_for_v1
- blocks_release: no

Analyze smoke does not prove that a native Linux desktop bundle can be produced or launched.

### Build Smoke

- command: `cd apps/desktop_flutter && flutter build linux`
- purpose: native Linux desktop bundle generation
- current_status: passed
- classification: required_for_v1
- blocks_release: no
- evidence: `build/linux/x64/release/bundle/gui_shell_desktop`
- required_action: Keep Linux desktop project files and pass `flutter build linux` on release candidates.

Linux desktop build dependencies are now present according to `flutter doctor -v`:

- clang: Ubuntu clang version 21.1.8
- cmake: 4.2.3
- ninja: 1.13.2
- pkg-config: 2.5.1

Linux desktop build smoke is resolved as of 2026-05-25.

### Launch Smoke

- command: `cd apps/desktop_flutter && ./build/linux/x64/release/bundle/gui_shell_desktop`
- purpose: verify first-window startup from the built desktop artifact
- current_status: passed
- classification: required_for_v1
- blocks_release: no
- evidence: first window opened under WSLg; Dashboard visible; NavigationRail visible; Runtime Status visible; Invariant Status visible
- required_action: Keep Linux desktop launch smoke passing on release candidates.

WSLg emitted libEGL/MESA warnings in the terminal during launch. These warnings are a `known_limitation`, not a `release_blocker`, unless rendering or stability fails in future smoke runs.

## Release Gate

- item: Linux desktop build smoke
  classification: required_for_v1
  reason: `cd apps/desktop_flutter && flutter build linux` passed on 2026-05-25 and produced `build/linux/x64/release/bundle/gui_shell_desktop`.
  required_action: Keep Linux desktop build smoke passing on release candidates.
  blocks_release: no

- item: Linux desktop launch smoke
  classification: required_for_v1
  reason: `cd apps/desktop_flutter && ./build/linux/x64/release/bundle/gui_shell_desktop` launched successfully under WSLg on 2026-05-25 and first-window evidence was recorded.
  required_action: Keep Linux desktop launch smoke passing on release candidates.
  blocks_release: no

- item: WSLg libEGL/MESA graphics warnings
  classification: known_limitation
  reason: warnings appeared in terminal during WSLg launch but did not prevent the gui_shell_desktop window from opening or rendering Dashboard, NavigationRail, Runtime Status, and Invariant Status.
  required_action: Reclassify as `release_blocker` if rendering or stability fails.
  blocks_release: no
