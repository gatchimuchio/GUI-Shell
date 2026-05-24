from __future__ import annotations

import json
import shutil
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]


def check_tool(name: str, recovery: str, required: bool = True) -> dict:
    found = shutil.which(name) is not None
    return {
        "check_id": f"tool.{name}",
        "status": "pass" if found else ("fail" if required else "warning"),
        "message": f"{name} {'found' if found else 'not found'}",
        "recovery_instruction": None if found else recovery,
        "grants_authority": False,
    }


def check_path(path: Path, check_id: str, recovery: str) -> dict:
    exists = path.exists()
    return {
        "check_id": check_id,
        "status": "pass" if exists else "fail",
        "message": f"{path.relative_to(ROOT)} {'exists' if exists else 'missing'}",
        "recovery_instruction": None if exists else recovery,
        "grants_authority": False,
    }


def setup_doctor_report() -> dict:
    checks = [
        check_tool("python3", "Install Python 3 and rerun Setup Doctor."),
        check_tool("cargo", "Install Rust/Cargo before running native helper tests.", required=False),
        check_tool("flutter", "Install Flutter before analyzing or launching the desktop operator shell.", required=False),
        check_path(ROOT / "packages" / "blue_tanuki_adapter", "adapter.readiness", "Restore the BLUE-TANUKI adapter package."),
        check_path(ROOT / "examples" / "contracts" / "update.valid.json", "update.policy", "Restore update policy contract examples."),
        check_path(ROOT / "examples" / "contracts" / "audit.valid.json", "audit.storage_contract", "Restore audit contract examples."),
        check_path(ROOT / "examples" / "contracts" / "recovery.valid.json", "recovery.catalog", "Restore recovery contract examples."),
    ]
    status = "pass" if all(check["status"] == "pass" for check in checks) else "warning"
    return {
        "status": status,
        "checks": checks,
        "installer_grants_authority": False,
        "installer_silently_approves_permissions": False,
        "operator_readable": True,
    }


def main() -> int:
    print(json.dumps(setup_doctor_report(), indent=2, sort_keys=True))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
