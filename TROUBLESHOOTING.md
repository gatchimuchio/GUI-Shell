# GUI Shell Troubleshooting

## `python: command not found`

Some hosts expose Python as `python3`.

Use:

```bash
python3 tooling/schema_check/check_schemas.py
python3 tooling/conformance_tests/run_conformance_skeleton.py
```

## Schema validation fails

Check:

- JSON syntax in `specs/*.schema.json`;
- required draft declaration;
- duplicate or malformed `$id`;
- accidental Flutter-specific or BLUE-TANUKI-specific fields in core contracts.

Then rerun:

```bash
python tooling/schema_check/check_schemas.py
```

## Conformance skeleton fails

Check that conformance still covers:

- adapter authority strip;
- content exposure boundary;
- approval edit restrictions;
- sensitive action audit/recovery mapping.

Then rerun:

```bash
python tooling/conformance_tests/run_conformance_skeleton.py
```

## Rust is not installed

Skip the conditional Rust command and report it as not run:

```bash
cd native/rust_helper && cargo test
```

## Flutter is not installed

Skip the conditional Flutter command and report it as not run:

```bash
cd apps/desktop_flutter && flutter analyze
```

## Product UI work seems blocked

This is expected when schemas or conformance tests are incomplete. GUI Shell is schema-first and conformance-first, so the next task should usually be the smallest missing schema or conformance check, not a UI screen.
