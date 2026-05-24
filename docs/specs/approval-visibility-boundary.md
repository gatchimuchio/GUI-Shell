# Approval Visibility Boundary

Approval UI must not imply that the user can approve what the runtime has not exposed.

## Full payload storage boundary

`full_payload` may exist in approval storage for hashing, revalidation, audit correlation, or later full-review use.

UI projection must never expose `full_payload` unless the effective approval contract has `content_visibility=full`.

If `content_visibility` is `none`, `hash_only`, `summary`, or `redacted`, the UI must render only the allowed projection and must not leak full payload values through labels, tooltips, logs, previews, search indexes, accessibility text, or debug views.

## Editable field constraints

- Editable fields must be explicitly declared by runtime.
- Authority fields are never editable.
- Hidden fields are never editable.
- Sealed fields are never editable.
- Sacred-domain fields are never editable.
- Runtime identity, permission identity, audit identity, and payload hash are never directly editable.

After edits:

- payload must be rehashed
- approval must be revalidated
- approval status must require validation when needed
- edit event must be audited
