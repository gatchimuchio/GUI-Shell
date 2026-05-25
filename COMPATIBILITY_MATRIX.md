# Compatibility Matrix

| Component | Status | Classification | Blocks release | Reason | Required action |
| --- | --- | --- | --- | --- | --- |
| Python Shell Core | passed | none | no | `schema_check` and `conformance_skeleton` passed in the current environment. | Keep running these checks before release. |
| Rust Helper | passed | none | no | Rust/Cargo are present and `cd native/rust_helper && cargo test` passed. | Ensure `$HOME/.cargo/bin` is on PATH in future shells; rerun cargo test before release. |
| Desktop Flutter | passed | none | no | Flutter SDK is present at `$HOME/dev/flutter`, `unzip` is present at `/usr/bin/unzip`, `flutter --version` passes, and `cd apps/desktop_flutter && flutter analyze` passed. | Keep desktop analyze in v1.0 validation. Install Linux desktop build dependencies before launch/build smoke. |
| Mobile Flutter | passed_optional | post_v1_scope | no | Mobile `flutter analyze` currently passes, but mobile full release is outside desktop-first v1.0 unless owner explicitly includes mobile. | No v1.0 action required unless owner changes release scope. |
| BLUE-TANUKI Adapter | mock_checked | post_v1_scope | no | BLUE-TANUKI product completion is outside GUI-Shell v1.0 gate; current validation is mock/contract oriented. | No v1.0 action unless owner changes scope. |
| Installer / Setup Doctor | development_checked | release_blocker | yes | Installed first-run smoke and real Setup Doctor diagnostics are not passed. | Add/run installed first-run smoke and Setup Doctor validation. |
| Runtime Catalog | development_checked | release_blocker | yes | Live/use smoke validation is not passed. | Pass Runtime Catalog validation and use smoke. |
| Agent Runtime | development_checked | release_blocker | yes | Mock/reference runtime smoke is not passed as a completed product gate. | Pass Agent Runtime Contract validation and mock/reference smoke. |
