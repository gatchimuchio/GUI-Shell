# Audit Evidence

Current evidence is contract-level.

- AuditEvent schema requires `event_id`, `timestamp`, `actor`, `action`, `target`, `result`, and `payload_hash`.
- PolicyEvaluator requires `audit_event.event_id`.
- PolicyEvaluator requires `audit_event.payload_hash` when payload exists.
- AuditStore maintains previous hash linkage in memory.
- Adapter mock exports audit events through generic AuditEvent schema.

Remaining before production:

- persistent audit storage
- tamper evidence over durable storage
- export verification tooling
- operator-facing audit chain validation
