# Rust Helper

Native helper boundary for operations that should not live in UI code.

Planned modules:

- process
- filesystem
- network
- diagnostics
- update_verification
- audit_hash
- secure_ipc

Rust helper must remain callable through explicit IPC or FFI boundaries.
