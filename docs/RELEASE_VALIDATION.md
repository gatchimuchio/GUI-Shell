# Release Validation

In this repository, "release" means completed product release.

- item: skeleton, preview, alpha, beta, and scaffold states
  classification: release_blocker
  reason: these states are not completed product release states.
  blocks_release: yes

## Development Validation

Development validation:

- schema check must pass
- conformance must pass
- unavailable toolchains may be recorded as `not_run`
  classification: release_blocker
  blocks_release: yes
- development validation is not suitable for completed product release
  classification: release_blocker
  blocks_release: yes

`not_run` is acceptable only in development validation.

## Release Validation

Release validation:

- no `not_run` allowed for in-scope components
- no unclassified remaining risk allowed
- any `release_blocker` fails validation
- `validate_all.py --strict-release` must pass
- `cargo test` must pass if Rust helper is in release scope
- desktop `flutter analyze` must pass if desktop app is in release scope
- mobile `flutter analyze` is required only if mobile is in release scope
- installer smoke must pass if installer is in release scope

`not_run` is a `release_blocker` in release validation for in-scope components.

## Classification Rules

- classification: `release_blocker`
  reason: Required for v1.0 completed product release and unfinished, unverified, failed, or not run.
  blocks_release: yes

- classification: `post_v1_scope`
  reason: Explicitly outside v1.0 completed desktop product scope.
  blocks_release: no

- classification: `known_limitation`
  reason: Accepted v1.0 limitation documented in release-facing claims.
  blocks_release: no
