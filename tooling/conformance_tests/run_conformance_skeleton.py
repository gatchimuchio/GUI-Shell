from pathlib import Path
import copy
import hashlib
import json

ROOT = Path(__file__).resolve().parents[2]
SPECS = ROOT / "specs"
DOC_SPECS = ROOT / "docs" / "specs"
CONTRACT_EXAMPLES = ROOT / "examples" / "contracts"

VISIBILITY_VALUES = ["none", "hash_only", "summary", "redacted", "full"]
AUTHORITY_KEYS = {
    "authority",
    "authority_context",
    "authority_fields",
    "approval_state",
    "capability_grants",
    "grants",
    "permission",
    "permissions",
    "privileges",
    "role",
    "trust_level",
}
PROTECTED_EDIT_FIELDS = {
    "runtime_id",
    "permission_id",
    "audit_id",
    "audit_event_id",
    "payload_hash",
}
NON_AUTHORITY_SOURCES = {"memory", "cache", "previous_state", "local_ui_state"}


def load_schema(name: str) -> dict:
    return json.loads((SPECS / name).read_text(encoding="utf-8"))


def load_contract_fixture(name: str) -> dict:
    return json.loads((CONTRACT_EXAMPLES / name).read_text(encoding="utf-8"))


def sha256_tagged(payload: bytes) -> str:
    return "sha256:" + hashlib.sha256(payload).hexdigest()


def canonical_hash(payload: object) -> str:
    encoded = json.dumps(payload, sort_keys=True, separators=(",", ":")).encode("utf-8")
    return sha256_tagged(encoded)


def strip_authority_keys(value):
    if isinstance(value, dict):
        return {
            key: strip_authority_keys(item)
            for key, item in value.items()
            if key not in AUTHORITY_KEYS
        }
    if isinstance(value, list):
        return [strip_authority_keys(item) for item in value]
    return value


def metadata_permissions(adapter: dict) -> list[str]:
    # Adapter metadata is descriptive only. Permission-like metadata must be ignored.
    return list(adapter.get("declared_capabilities", []))


def can_create_authority_context(source: str, runtime_allowed: bool) -> bool:
    return source == "runtime" and runtime_allowed


def source_can_grant_authority(source: str) -> bool:
    return source not in NON_AUTHORITY_SOURCES


def render_approval_content(approval: dict) -> dict:
    visibility = approval["content_visibility"]
    if visibility == "none":
        return {}
    if visibility == "hash_only":
        return {"payload_hash": approval["payload_hash"]}
    if visibility == "summary":
        return {"summary": approval.get("summary", "")}
    if visibility == "redacted":
        return {"redacted_payload": approval.get("redacted_payload", {})}
    if visibility == "full":
        return {"full_payload": approval.get("full_payload", {})}
    raise ValueError(f"unknown content visibility: {visibility}")


def protected_approval_fields(approval: dict) -> set[str]:
    return (
        set(approval.get("authority_fields", []))
        | set(approval.get("sealed_fields", []))
        | set(approval.get("hidden_fields", []))
        | set(approval.get("sacred_fields", []))
        | PROTECTED_EDIT_FIELDS
    )


def can_edit_approval_field(approval: dict, field: str) -> bool:
    return field in set(approval.get("editable_fields", [])) and field not in protected_approval_fields(approval)


def apply_approval_edit(approval: dict, field: str, value) -> dict:
    if not can_edit_approval_field(approval, field):
        raise ValueError(f"field is not editable: {field}")
    next_approval = copy.deepcopy(approval)
    payload = copy.deepcopy(next_approval.get("full_payload", {}))
    payload[field] = value
    next_approval["full_payload"] = payload
    next_approval["payload_hash"] = canonical_hash(payload)
    next_approval["status"] = "requires_validation"
    return next_approval


def sensitive_action_mapping_is_complete(action: dict) -> bool:
    required = {
        "capability_id",
        "permission_id",
        "approval_state",
        "audit_event",
        "recovery_action",
    }
    if not required.issubset(action):
        return False
    audit_event = action["audit_event"]
    recovery_action = action["recovery_action"]
    return bool(audit_event.get("event_id")) and bool(recovery_action.get("recovery_id"))


def test_required_docs_exist() -> list[str]:
    errors = []
    required_docs = {
        "adapter-conformance.md",
        "authority-strip-conformance.md",
        "content-exposure-policy.md",
        "approval-visibility-boundary.md",
    }
    existing = {path.name for path in DOC_SPECS.glob("*.md")}
    for missing in sorted(required_docs - existing):
        errors.append(f"docs/specs/{missing} missing")
    return errors


def test_contract_fixtures_are_available() -> list[str]:
    errors = []
    expected = {
        "runtime.valid.json",
        "adapter.valid.json",
        "capability.valid.json",
        "permission.valid.json",
        "approval.valid.json",
        "audit.valid.json",
        "recovery.valid.json",
        "diagnostic.valid.json",
        "update.valid.json",
        "content_exposure.valid.json",
        "framework_risk_profile.valid.json",
    }
    existing = {path.name for path in CONTRACT_EXAMPLES.glob("*.valid.json")}
    for missing in sorted(expected - existing):
        errors.append(f"examples/contracts/{missing} missing")
    for name in sorted(expected & existing):
        try:
            fixture = load_contract_fixture(name)
        except Exception as exc:
            errors.append(f"examples/contracts/{name} did not parse: {exc}")
            continue
        if not isinstance(fixture, dict):
            errors.append(f"examples/contracts/{name} must be a JSON object")
    return errors


def test_adapter_authority_strip_schema() -> list[str]:
    errors = []
    schema = load_schema("adapter.schema.json")
    required = set(schema.get("required", []))
    authority_strip = schema["properties"].get("authority_strip", {})
    if "authority_strip" not in required:
        errors.append("adapter.schema.json must require authority_strip")
    if authority_strip.get("const") is not True:
        errors.append("adapter.schema.json must require authority_strip=true")
    return errors


def test_inbound_authority_keys_are_stripped() -> list[str]:
    inbound = {
        "operation": "runtime.snapshot",
        "authority": "admin",
        "payload": {
            "message": "safe",
            "permissions": ["fs:write"],
            "nested": {"trust_level": "root", "value": 1},
        },
        "metadata": {"role": "owner", "source": "adapter"},
    }
    stripped = strip_authority_keys(inbound)
    encoded = json.dumps(stripped, sort_keys=True)
    errors = []
    for key in AUTHORITY_KEYS:
        if f'"{key}"' in encoded:
            errors.append(f"inbound authority key was not stripped: {key}")
    if stripped["payload"]["nested"].get("value") != 1:
        errors.append("authority strip removed safe nested payload")
    return errors


def test_external_metadata_cannot_escalate_authority() -> list[str]:
    adapter = load_contract_fixture("adapter.valid.json")
    adapter["metadata"] = {
        "permissions": ["fs:write"],
        "grants": ["all"],
        "trust_level": "root",
    }
    effective = metadata_permissions(adapter)
    if effective != adapter["declared_capabilities"]:
        return ["adapter metadata escalated effective permissions"]
    return []


def test_gui_input_cannot_create_runtime_disallowed_authority_context() -> list[str]:
    errors = []
    if can_create_authority_context("gui", runtime_allowed=True):
        errors.append("GUI input created authority context")
    if can_create_authority_context("adapter", runtime_allowed=True):
        errors.append("adapter input created authority context directly")
    if can_create_authority_context("runtime", runtime_allowed=False):
        errors.append("runtime-disallowed authority context was created")
    if not can_create_authority_context("runtime", runtime_allowed=True):
        errors.append("runtime-allowed authority context was denied")
    return errors


def test_memory_cache_previous_state_cannot_grant_authority() -> list[str]:
    errors = []
    for source in sorted(NON_AUTHORITY_SOURCES):
        if source_can_grant_authority(source):
            errors.append(f"{source} granted authority")
    return errors


def test_content_exposure_contract() -> list[str]:
    schema = load_schema("content_exposure.schema.json")
    fixture = load_contract_fixture("content_exposure.valid.json")
    errors = []
    default_visibility = schema["properties"]["default_visibility"]
    if default_visibility.get("const") != "none":
        errors.append("content exposure default_visibility must be const none")
    if fixture.get("default_visibility") != "none":
        errors.append("content exposure valid fixture default_visibility must be none")
    enum = schema["properties"]["allowed_visibility"]["items"]["enum"]
    if enum != VISIBILITY_VALUES:
        errors.append("content exposure allowed_visibility enum must match locked order")
    return errors


def test_full_content_only_visible_when_full() -> list[str]:
    base = load_contract_fixture("approval.valid.json")
    errors = []
    for visibility in VISIBILITY_VALUES:
        rendered = render_approval_content({**base, "content_visibility": visibility})
        if visibility != "full" and "full_payload" in rendered:
            errors.append(f"full payload rendered for content_visibility={visibility}")
        if visibility == "hash_only" and set(rendered) != {"payload_hash"}:
            errors.append("hash_only rendered more than payload_hash")
        if visibility == "none" and rendered:
            errors.append("none visibility rendered content")
    return errors


def test_approval_schema_has_protected_field_sets() -> list[str]:
    schema = load_schema("approval.schema.json")
    properties = schema.get("properties", {})
    errors = []
    for field in ["authority_fields", "sealed_fields", "hidden_fields", "sacred_fields"]:
        if field not in properties:
            errors.append(f"approval.schema.json missing {field}")
    return errors


def test_protected_approval_fields_cannot_be_edited() -> list[str]:
    approval = load_contract_fixture("approval.valid.json")
    approval["editable_fields"] = [
        "path",
        "authority_context",
        "runtime_id",
        "credential",
        "permission_id",
        "payload_hash",
    ]
    errors = []
    for field in ["authority_context", "runtime_id", "credential", "permission_id", "payload_hash"]:
        if can_edit_approval_field(approval, field):
            errors.append(f"protected approval field was editable: {field}")
    if not can_edit_approval_field(approval, "path"):
        errors.append("allowed non-protected approval field was not editable")
    return errors


def test_approval_edits_are_rehashed_and_revalidated() -> list[str]:
    approval = {
        "status": "pending",
        "payload_hash": canonical_hash({"allowed_note": "before"}),
        "editable_fields": ["allowed_note"],
        "authority_fields": [],
        "sealed_fields": [],
        "hidden_fields": [],
        "sacred_fields": [],
        "full_payload": {"allowed_note": "before"},
    }
    edited = apply_approval_edit(approval, "allowed_note", "after")
    errors = []
    if edited["payload_hash"] == approval["payload_hash"]:
        errors.append("approval edit did not change payload_hash")
    if edited["payload_hash"] != canonical_hash({"allowed_note": "after"}):
        errors.append("approval edit payload_hash was not canonical")
    if edited["status"] != "requires_validation":
        errors.append("approval edit did not require revalidation")
    return errors


def test_sensitive_actions_map_to_audit_and_recovery() -> list[str]:
    capability = load_contract_fixture("capability.valid.json")
    permission = load_contract_fixture("permission.valid.json")
    audit_event = load_contract_fixture("audit.valid.json")
    recovery_action = load_contract_fixture("recovery.valid.json")
    complete = {
        "capability_id": capability["capability_id"],
        "permission_id": permission["permission_id"],
        "approval_state": "approved",
        "audit_event": audit_event,
        "recovery_action": recovery_action,
    }
    incomplete = {
        "capability_id": "filesystem.write",
        "permission_id": "permission.fs.write.workspace",
        "approval_state": "approved",
        "audit_event": {"event_id": "audit-1"},
    }
    errors = []
    if not sensitive_action_mapping_is_complete(complete):
        errors.append("complete sensitive action mapping was rejected")
    if sensitive_action_mapping_is_complete(incomplete):
        errors.append("sensitive action mapping passed without RecoveryAction")
    return errors


def test_hash_patterns_are_tagged_sha256() -> list[str]:
    errors = []
    sample = sha256_tagged(b"approval")
    if not sample.startswith("sha256:") or len(sample) != 71:
        errors.append("sha256_tagged helper invariant failed")
    for schema_name in ["approval.schema.json", "audit.schema.json"]:
        schema = load_schema(schema_name)
        pattern = schema["properties"]["payload_hash"].get("pattern", "")
        if "sha256:" not in pattern:
            errors.append(f"{schema_name} payload_hash must use tagged sha256 pattern")
    return errors


def test_framework_risk_profile_exists() -> list[str]:
    path = SPECS / "framework_risk_profile.schema.json"
    if not path.exists():
        return ["framework_risk_profile.schema.json missing"]
    return []


def test_update_fixture_requires_signature() -> list[str]:
    update = load_contract_fixture("update.valid.json")
    if update.get("signature_required") is not True:
        return ["update valid fixture does not require signatures"]
    return []


def main() -> int:
    tests = [
        test_required_docs_exist,
        test_contract_fixtures_are_available,
        test_adapter_authority_strip_schema,
        test_inbound_authority_keys_are_stripped,
        test_external_metadata_cannot_escalate_authority,
        test_gui_input_cannot_create_runtime_disallowed_authority_context,
        test_memory_cache_previous_state_cannot_grant_authority,
        test_content_exposure_contract,
        test_full_content_only_visible_when_full,
        test_approval_schema_has_protected_field_sets,
        test_protected_approval_fields_cannot_be_edited,
        test_approval_edits_are_rehashed_and_revalidated,
        test_sensitive_actions_map_to_audit_and_recovery,
        test_hash_patterns_are_tagged_sha256,
        test_framework_risk_profile_exists,
        test_update_fixture_requires_signature,
    ]
    errors = []
    for test in tests:
        errors.extend(test())

    if errors:
        print("conformance skeleton failed:")
        for err in errors:
            print(f"  - {err}")
        return 1

    print(f"conformance skeleton passed: {len(tests)} checks")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
