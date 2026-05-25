# Product Completion Plan

GUI-Shell v1.0 means completed desktop product release, not alpha, tech preview, or skeleton release.

## v1.0 Scope

- Desktop-first
- Single-user
- Local-first
- Runtime and Agent Operation Shell
- Installer / first-run flow
- Setup Doctor
- Runtime Catalog
- Agent Runtime Contract
- Shell Core persistence
- Permission / Approval / Audit / Recovery
- Audit chain verification
- Rust helper validated
- Desktop Flutter validated
- Mock/reference runtime
- Mock/reference agent

## Not v1.0

- completed mobile companion
- multi-user
- cloud service
- runtime marketplace
- BLUE-TANUKI product completion
- all live coding-agent adapters
- enterprise admin

## Completion Order

1. Claim and roadmap redefinition
2. Toolchain validation
3. Runtime Catalog
4. Agent Runtime Contract
5. Shell Core persistence
6. Audit chain persistence and verification
7. Setup Doctor hardening
8. Desktop UI live wiring
9. Installer first-run flow
10. Reference Runtime / Reference Agent connection
11. Release gate

## Hard Gate

v1.0 requires:

- `cargo test` passed
- `flutter analyze` passed for desktop
- `python3 tooling/validate_all.py` passed without required checks skipped
- desktop app launches
- installer first-run passes
- Setup Doctor real diagnostics pass
- Runtime Catalog validation passes
- Agent Runtime Contract validation passes
- Shell Core persistence passes
- audit chain verification passes
- approval edit, rehash, and revalidation passes
- content visibility UI enforcement passes
- workspace boundary enforcement passes
- mock/reference runtime smoke passes
- mock/reference agent smoke passes
- README / CLAIM / RELEASE_CHECKLIST support completed-product claim
- Owner GO
