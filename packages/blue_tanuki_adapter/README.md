# blue_tanuki_adapter

Reference adapter for BLUE-TANUKI.

Rules:

- BLUE-TANUKI is frozen as the Phase 0 reference runtime contract target.
- Adapter translates GUI Shell contracts to BLUE-TANUKI runtime endpoints.
- No BLUE-TANUKI-specific behavior may leak into Shell Core.
- Adapter metadata is untrusted and must not escalate authority.
