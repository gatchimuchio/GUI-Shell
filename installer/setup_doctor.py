from __future__ import annotations

import json
import os
import platform
import socket
import shutil
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]


def check_result(
    check_id: str,
    status: str,
    message: str,
    recovery_action: str | None,
    *,
    technical_detail: str = "",
    can_continue: bool = True,
) -> dict:
    return {
        "check_id": check_id,
        "status": status,
        "message": message,
        "technical_detail": technical_detail,
        "recovery_action": recovery_action,
        "recovery_instruction": recovery_action,
        "can_continue": can_continue,
        "grants_authority": False,
    }


def check_tool(name: str, recovery: str, required: bool = True) -> dict:
    path = shutil.which(name)
    return check_result(
        f"tool.{name}",
        "pass" if path else ("fail" if required else "warning"),
        f"{name} {'found' if path else 'not found'}",
        None if path else recovery,
        technical_detail=path or "not on PATH",
        can_continue=bool(path) or not required,
    )


def check_path(path: Path, check_id: str, recovery: str) -> dict:
    exists = path.exists()
    return check_result(
        check_id,
        "pass" if exists else "fail",
        f"{path.relative_to(ROOT)} {'exists' if exists else 'missing'}",
        None if exists else recovery,
        technical_detail=str(path),
        can_continue=exists,
    )


def check_os() -> dict:
    return check_result("host.os", "pass", f"OS: {platform.system()}", None, technical_detail=platform.platform())


def check_arch() -> dict:
    return check_result("host.arch", "pass", f"CPU architecture: {platform.machine()}", None, technical_detail=platform.processor())


def check_port_available(port: int) -> dict:
    with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as sock:
        sock.settimeout(0.2)
        result = sock.connect_ex(("127.0.0.1", port))
    available = result != 0
    return check_result(
        f"port.{port}",
        "pass" if available else "warning",
        f"localhost port {port} {'available' if available else 'already in use'}",
        None if available else f"Stop the process using port {port} or choose a different runtime port.",
        technical_detail=f"connect_ex={result}",
        can_continue=True,
    )


def check_public_bind() -> dict:
    return check_result(
        "network.public_bind",
        "warning",
        "Public bind requires explicit operator review",
        "Keep runtimes on localhost unless a permission and approval explicitly allow public bind.",
        technical_detail="0.0.0.0 and external interfaces are not approved by default",
        can_continue=True,
    )


def check_filesystem_permission(path: Path) -> dict:
    try:
        path.mkdir(parents=True, exist_ok=True)
        probe = path / ".write-test"
        probe.write_text("ok", encoding="utf-8")
        probe.unlink()
        writable = True
    except OSError as exc:
        writable = False
        detail = str(exc)
    else:
        detail = str(path)
    return check_result(
        "filesystem.permission",
        "pass" if writable else "fail",
        f"audit storage path {'writable' if writable else 'not writable'}",
        None if writable else "Choose a writable local audit storage directory.",
        technical_detail=detail,
        can_continue=writable,
    )


def setup_doctor_report() -> dict:
    audit_storage = Path(os.environ.get("GUI_SHELL_AUDIT_DIR", ROOT / ".gui-shell" / "audit"))
    checks = [
        check_os(),
        check_arch(),
        check_tool("python3", "Install Python 3 and rerun Setup Doctor."),
        check_tool("cargo", "Install Rust/Cargo before running native helper tests.", required=False),
        check_tool("flutter", "Install Flutter before analyzing or launching the desktop operator shell.", required=False),
        check_port_available(11434),
        check_public_bind(),
        check_filesystem_permission(audit_storage),
        check_path(ROOT / "examples" / "contracts" / "runtime_manifest.valid.json", "runtime.catalog", "Restore runtime manifest contract examples."),
        check_path(ROOT / "examples" / "contracts" / "adapter_manifest.valid.json", "adapter.manifest", "Restore adapter manifest contract examples."),
        check_path(ROOT / "examples" / "contracts" / "agent_workspace.valid.json", "agent.workspace_boundary", "Restore agent workspace contract examples."),
        check_path(ROOT / "packages" / "blue_tanuki_adapter", "adapter.readiness", "Restore the reference adapter package."),
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
