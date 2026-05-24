# blue_tanuki_adapter

Reference adapter for BLUE-TANUKI.

Rules:

- BLUE-TANUKI implementation is frozen.
- Adapter translates GUI Shell contracts to BLUE-TANUKI runtime endpoints.
- No BLUE-TANUKI-specific behavior may leak into Shell Core.
- Adapter metadata is untrusted and must not escalate authority.
