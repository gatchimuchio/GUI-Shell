# Content Exposure Policy

## Visibility levels

```text
none
hash_only
summary
redacted
full
```

## Rules

- `none`: raw content must not be shown.
- `hash_only`: only payload hash may be shown.
- `summary`: only runtime/adapter-approved summary may be shown.
- `redacted`: only redacted diff/content may be shown.
- `full`: full content may be shown.

## Default

Default is `none`.

Policies may allow stronger visibility values, but the safe default must remain `none`.

Full payload display is permitted only when the effective approval or content exposure contract says `content_visibility=full`.
