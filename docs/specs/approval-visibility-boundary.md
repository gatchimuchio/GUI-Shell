# Approval Visibility Boundary

Approval UI must not imply that the user can approve what the runtime has not exposed.

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
