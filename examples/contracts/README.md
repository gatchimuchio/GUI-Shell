# Contract Examples

These files are valid example instances for `specs/*.schema.json`.

`tooling/schema_check/check_schemas.py` validates every `*.valid.json` file against the matching schema using the repository's built-in schema subset checker.

The examples are not runtime state and do not grant authority. They exist to keep Phase 1 contracts executable before product UI exists.

Mapping:

```text
runtime.valid.json -> specs/runtime.schema.json
adapter.valid.json -> specs/adapter.schema.json
capability.valid.json -> specs/capability.schema.json
permission.valid.json -> specs/permission.schema.json
approval.valid.json -> specs/approval.schema.json
audit.valid.json -> specs/audit.schema.json
recovery.valid.json -> specs/recovery.schema.json
diagnostic.valid.json -> specs/diagnostic.schema.json
update.valid.json -> specs/update.schema.json
content_exposure.valid.json -> specs/content_exposure.schema.json
framework_risk_profile.valid.json -> specs/framework_risk_profile.schema.json
```
