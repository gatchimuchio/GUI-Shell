from __future__ import annotations

import json
from pathlib import Path

from .setup_doctor import setup_doctor_report


def first_run_smoke(app_root: Path) -> dict:
    app_root.mkdir(parents=True, exist_ok=True)
    config_dir = app_root / "config"
    audit_dir = app_root / "audit"
    config_dir.mkdir(parents=True, exist_ok=True)
    audit_dir.mkdir(parents=True, exist_ok=True)

    config_path = config_dir / "gui_shell.json"
    if not config_path.exists():
        config_path.write_text(
            json.dumps(
                {
                    "first_run_complete": True,
                    "installer_grants_authority": False,
                    "installer_silently_approves_permissions": False,
                    "audit_dir": str(audit_dir),
                },
                sort_keys=True,
                indent=2,
            ),
            encoding="utf-8",
        )

    probe = audit_dir / ".write-test"
    probe.write_text("ok", encoding="utf-8")
    probe.unlink()

    setup_report = setup_doctor_report()
    errors: list[str] = []
    if setup_report.get("installer_grants_authority") is not False:
        errors.append("setup doctor grants authority")
    if setup_report.get("installer_silently_approves_permissions") is not False:
        errors.append("setup doctor silently approves permissions")
    if any(check.get("grants_authority") is not False for check in setup_report.get("checks", [])):
        errors.append("setup doctor check grants authority")

    return {
        "ok": not errors,
        "errors": errors,
        "config_path": str(config_path),
        "audit_dir": str(audit_dir),
        "config_created": config_path.exists(),
        "audit_dir_writable": True,
        "setup_doctor_status": setup_report.get("status"),
        "installer_grants_authority": False,
        "installer_silently_approves_permissions": False,
    }
