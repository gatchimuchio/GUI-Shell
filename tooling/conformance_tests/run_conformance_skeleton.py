from pathlib import Path
import json
import hashlib
import sys

ROOT = Path(__file__).resolve().parents[2]
SPECS = ROOT / "specs"

VISIBILITY_ORDER = ["none", "hash_only", "summary", "redacted", "full"]

def sha256_tagged(payload: bytes) -> str:
    return "sha256:" + hashlib.sha256(payload).hexdigest()

def test_adapter_authority_strip_schema() -> list[str]:
    errors = []
    schema = json.loads((SPECS / "adapter.schema.json").read_text(encoding="utf-8"))
    authority_strip = schema["properties"].get("authority_strip", {})
    if authority_strip.get("const") is not True:
        errors.append("adapter.schema.json must require authority_strip=true")
    return errors

def test_content_exposure_default_is_safe() -> list[str]:
    errors = []
    schema = json.loads((SPECS / "content_exposure.schema.json").read_text(encoding="utf-8"))
    enum = schema["properties"]["default_visibility"]["enum"]
    if "none" not in enum:
        errors.append("content exposure default_visibility must allow none")
    return errors

def test_approval_hash_pattern() -> list[str]:
    errors = []
    schema = json.loads((SPECS / "approval.schema.json").read_text(encoding="utf-8"))
    pattern = schema["properties"]["payload_hash"].get("pattern", "")
    if "sha256:" not in pattern:
        errors.append("approval payload_hash must use tagged sha256 pattern")
    sample = sha256_tagged(b"approval")
    if not sample.startswith("sha256:") or len(sample) != 71:
        errors.append("sha256_tagged helper invariant failed")
    return errors

def test_framework_risk_profile_exists() -> list[str]:
    path = SPECS / "framework_risk_profile.schema.json"
    if not path.exists():
        return ["framework_risk_profile.schema.json missing"]
    return []

def main() -> int:
    tests = [
        test_adapter_authority_strip_schema,
        test_content_exposure_default_is_safe,
        test_approval_hash_pattern,
        test_framework_risk_profile_exists,
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
