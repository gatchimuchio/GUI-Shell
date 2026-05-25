# Authority Strip Conformance

Authority Strip Conformance prevents inbound runtime, adapter, UI, memory, cache, or metadata values from creating authority inside GUI Shell.

## MUST

- Strip inbound authority keys before Shell Core evaluates a request.
- Treat adapter metadata as untrusted descriptive data.
- Reject or ignore external attempts to set permission, approval, grant, actor, or authority context.
- Preserve runtime-declared boundaries without broadening them.
- Record audit evidence for stripped sensitive authority material when safe to do so.

## MUST NOT

- Let GUI input create runtime-disallowed authority context.
- Let adapter metadata grant permissions.
- Let memory, local cache, complete history, previous state, or remembered UI state grant authority by itself.
- Infer approval from previous display, previous selection, or local UI state.
- Convert runtime-specific authority concepts into Shell Core authority without explicit schema and conformance coverage.

## Authority-like inbound keys

The conformance baseline treats these inbound keys as authority-like and strips them unless explicitly owned by a validated Shell Core contract:

```text
authority
authority_context
authority_trace
approval_state
approved_by
permission_grant
permission_override
role
scope_escalation
trust_level
```

Nested authority-like keys must also be stripped.

## Pass condition

After strip, the request may retain payload, runtime identity, operation identity, safe metadata, and hashes. It must not retain inbound authority-like keys that can grant permission, approval, privilege, or trust.
