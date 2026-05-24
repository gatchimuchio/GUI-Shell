# GUI Shell Claim Boundary

## Current claim

GUI Shell is a generic Runtime Operation Shell skeleton with Phase 3H through Phase 9 release-hardening scaffolding.

It claims:

- schema-first contracts for runtime operation shell concepts;
- conformance-first work order with 53 checks in the current skeleton;
- framework-independent Shell Core hardening for permissions, approvals, audit, recovery, policy evaluation, and deterministic state snapshots;
- bounded Rust helper boundary skeleton;
- BLUE-TANUKI as a reference runtime through adapter contract only;
- desktop and mobile Flutter operator skeletons that do not own authority;
- Setup Doctor skeleton with explicit non-authority installer status;
- release-hardening documents with explicit non-production claim boundary.

## Not claimed

GUI Shell does not yet claim:

- production readiness;
- signed native installer readiness;
- stable mobile companion readiness;
- BLUE-TANUKI feature parity;
- live runtime permission enforcement outside the schema/conformance skeleton;
- complete Rust helper implementation;
- complete Flutter product UI;
- stable live BLUE-TANUKI integration;
- security completeness.

## Promotion condition

Any stronger claim must be backed by:

- schema validation;
- conformance validation;
- Rust helper tests when Rust is installed;
- Flutter analysis when Flutter is installed;
- mobile Flutter analysis when Flutter is installed;
- audit evidence for each sensitive action path;
- explicit owner decision for release promotion.
