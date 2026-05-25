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
- current_status: failed
- classification: release_blocker
- blocks_release: yes
- exact_error: `No Linux desktop project configured. See https://flutter.dev/to/add-desktop-support to learn about adding Linux support to a project.`
- required_action: Add the Linux desktop project files for `apps/desktop_flutter` through the approved Flutter desktop support path, preserve Shell Core / UI / Adapter boundaries, then rerun `flutter build linux`.

Linux desktop build dependencies are now present according to `flutter doctor -v`:

- clang: Ubuntu clang version 21.1.8
- cmake: 4.2.3
- ninja: 1.13.2
- pkg-config: 2.5.1

The remaining build failure is project configuration, not missing system build dependencies.

### Launch Smoke

- command: launch the produced Linux desktop bundle after `flutter build linux` succeeds
- purpose: verify first-window startup from the built desktop artifact
- current_status: blocked_by_build
- classification: release_blocker
- blocks_release: yes
- reason: launch smoke requires a successful Linux desktop build artifact.
- required_action: Pass Linux build smoke first, then run and record desktop launch smoke.

## Release Gate

- item: Linux desktop build smoke
  classification: release_blocker
  reason: `flutter build linux` fails because no Linux desktop project is configured.
  required_action: Add Linux desktop project support and pass `cd apps/desktop_flutter && flutter build linux`.
  blocks_release: yes

- item: Linux desktop launch smoke
  classification: release_blocker
  reason: no launchable Linux desktop build artifact exists yet.
  required_action: Launch the built Linux desktop artifact and record first-window startup evidence.
  blocks_release: yes
