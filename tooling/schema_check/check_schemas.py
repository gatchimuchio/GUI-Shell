from pathlib import Path
import json
import sys

ROOT = Path(__file__).resolve().parents[2]
SPECS = ROOT / "specs"

REQUIRED = {
    "runtime.schema.json",
    "adapter.schema.json",
    "capability.schema.json",
    "permission.schema.json",
    "approval.schema.json",
    "audit.schema.json",
    "recovery.schema.json",
    "diagnostic.schema.json",
    "update.schema.json",
    "content_exposure.schema.json",
    "framework_risk_profile.schema.json",
}

def main() -> int:
    missing = sorted(REQUIRED - {p.name for p in SPECS.glob("*.schema.json")})
    if missing:
        print("missing schemas:")
        for name in missing:
            print(f"  - {name}")
        return 1

    errors = []
    for path in sorted(SPECS.glob("*.schema.json")):
        try:
            data = json.loads(path.read_text(encoding="utf-8"))
        except Exception as exc:
            errors.append(f"{path}: invalid json: {exc}")
            continue
        for key in ["$schema", "$id", "title", "type"]:
            if key not in data:
                errors.append(f"{path}: missing {key}")

    if errors:
        print("schema check failed:")
        for err in errors:
            print(f"  - {err}")
        return 1

    print(f"schema check passed: {len(list(SPECS.glob('*.schema.json')))} schemas")
    return 0

if __name__ == "__main__":
    raise SystemExit(main())
