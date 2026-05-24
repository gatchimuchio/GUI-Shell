# Installer Boundary

The installer may prepare files, dependencies, launchers, and first-run status.

The installer must not:

- grant permissions
- approve actions
- hide dependency failures
- bypass Shell Core policy evaluation
- bypass audit
- bypass recovery mapping

Authority remains in Shell Core. Runtime-specific readiness remains behind adapter contracts.
