# Compatibility Matrix

| Component | Status | Classification | Blocks release | Reason | Required action |
| --- | --- | --- | --- | --- | --- |
| Python Shell Core | passed | none | no | `schema_check` and `conformance_skeleton` passed in the current environment. | Keep running these checks before release. |
| Rust Helper | passed | none | no | Rust/Cargo are present and `cd native/rust_helper && cargo test` passed. | Ensure `$HOME/.cargo/bin` is on PATH in future shells; rerun cargo test before release. |
| Desktop Flutter analyze | passed | none | no | Flutter SDK is present at `$HOME/dev/flutter`, `unzip` is present at `/usr/bin/unzip`, `flutter --version` passes, and `cd apps/desktop_flutter && flutter analyze` passed on 2026-05-25. | Keep desktop analyze in v1.0 validation. |
| Desktop Flutter Linux toolchain | passed | none | no | `flutter doctor -v` reports the Linux desktop toolchain is present: clang 21.1.8, cmake 4.2.3, ninja 1.13.2, and pkg-config 2.5.1. | Keep Linux desktop build dependencies installed for release candidates. |
| Desktop Flutter widget test | passed | none | no | `cd apps/desktop_flutter && flutter test` passed on 2026-05-25 after the smoke test was updated for multiple `Dashboard` labels. | Keep widget smoke in desktop validation. |
| Desktop Flutter Linux build | passed | none | no | `cd apps/desktop_flutter && flutter build linux` passed on 2026-05-25 and produced `build/linux/x64/release/bundle/gui_shell_desktop`. | Keep Linux desktop build smoke in v1.0 validation. |
| Desktop Flutter Linux launch | passed | none | no | `./build/linux/x64/release/bundle/gui_shell_desktop` launched successfully under WSLg on 2026-05-25; the first window opened with Dashboard, NavigationRail, Runtime Status, and Invariant Status visible. | Keep Linux desktop launch smoke in v1.0 validation. |
| WSLg graphics warnings | observed | known_limitation | no | Terminal emitted libEGL/MESA warnings under WSLg, but they did not prevent the app window from launching or rendering the first screen evidence. | Treat as non-blocking unless rendering or stability fails. |
| Mobile Flutter | passed_optional | post_v1_scope | no | Mobile `flutter analyze` currently passes, but mobile full release is outside desktop-first v1.0 unless owner explicitly includes mobile. | No v1.0 action required unless owner changes release scope. |
| BLUE-TANUKI Adapter | mock_checked | post_v1_scope | no | BLUE-TANUKI product completion is outside GUI-Shell v1.0 gate; current validation is mock/contract oriented. | No v1.0 action unless owner changes scope. |
| Installer / Setup Doctor | development_checked | release_blocker | yes | Installed first-run smoke and real Setup Doctor diagnostics remain unpassed release criteria. | Add/run installed first-run smoke and Setup Doctor validation. |
| Runtime Catalog | development_checked | release_blocker | yes | Live/use smoke validation is not passed. | Pass Runtime Catalog validation and use smoke. |
| Agent Runtime | development_checked | release_blocker | yes | Mock/reference runtime smoke is not passed as a completed product gate. | Pass Agent Runtime Contract validation and mock/reference smoke. |
