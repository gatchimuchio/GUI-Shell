# Adapter Conformance

## Goal

Adapters connect GUI Shell to external runtimes without leaking authority across the boundary.

## MUST

- Strip inbound authority keys.
- Reject external authority escalation.
- Validate all adapter messages against `adapter.schema.json`.
- Preserve runtime-declared permission boundaries.
- Preserve content exposure policy.
- Emit audit events for sensitive adapter actions.
- Return diagnostic information without exposing sealed fields.
- Strip nested authority-like keys from inbound adapter payloads.
- Treat `metadata` as descriptive and untrusted even when it contains grant-like keys.

## MUST NOT

- Treat runtime metadata as trusted authority.
- Create authority context not granted by runtime.
- Display raw payloads beyond allowed visibility.
- Edit sealed, hidden, sacred, or authority fields.
- Convert metadata, memory, cache, or previous state into permission.
