from __future__ import annotations

import argparse
import json
import re
from dataclasses import dataclass
from pathlib import Path
from typing import Any


ROOT = Path(__file__).resolve().parents[1]
DEFAULT_EVIDENCE_PATH = ROOT / "release_evidence" / "windows_installed_smoke.json"
SHA256_RE = re.compile(r"^sha256:[0-9a-f]{64}$")


@dataclass(frozen=True)
class EvidenceResult:
    name: str
    status: str
    classification: str
    blocks_release: str
    reason: str
    required_action: str


def _failed(name: str, reason: str, required_action: str) -> EvidenceResult:
    return EvidenceResult(name, "failed", "release_blocker", "yes", reason, required_action)


def _passed(name: str, reason: str, required_action: str) -> EvidenceResult:
    return EvidenceResult(name, "passed", "none", "no", reason, required_action)


def _get(data: dict[str, Any], dotted: str) -> Any:
    value: Any = data
    for part in dotted.split("."):
        if not isinstance(value, dict) or part not in value:
            return None
        value = value[part]
    return value


def _is_false(data: dict[str, Any], dotted: str) -> bool:
    return _get(data, dotted) is False


def _is_true(data: dict[str, Any], dotted: str) -> bool:
    return _get(data, dotted) is True


def load_evidence(path: Path = DEFAULT_EVIDENCE_PATH) -> tuple[dict[str, Any] | None, str | None]:
    if not path.exists():
        return None, f"{path.relative_to(ROOT)} missing"
    try:
        payload = json.loads(path.read_text(encoding="utf-8"))
    except json.JSONDecodeError as exc:
        return None, f"{path.relative_to(ROOT)} is invalid JSON: {exc}"
    if not isinstance(payload, dict):
        return None, f"{path.relative_to(ROOT)} must contain a JSON object"
    return payload, None


def validate_installer_first_run(data: dict[str, Any]) -> EvidenceResult:
    errors: list[str] = []
    if data.get("platform") != "windows":
        errors.append("platform must be windows")
    if not SHA256_RE.match(str(_get(data, "artifact.sha256") or "")):
        errors.append("artifact.sha256 must be tagged sha256")
    if not _is_true(data, "artifact.installed_exe_exists"):
        errors.append("installed executable existence was not confirmed")
    if _get(data, "first_run.status") != "passed":
        errors.append("first_run.status must be passed")
    if not _is_true(data, "first_run.launched_from_installed_path"):
        errors.append("first run did not launch from installed app path")
    if not _is_true(data, "first_run.first_window_visible"):
        errors.append("first window visibility was not confirmed")
    for label in ["Dashboard", "NavigationRail", "Runtime Status", "Invariant Status"]:
        if label not in (_get(data, "first_run.visible_surfaces") or []):
            errors.append(f"{label} was not recorded as visible")
    if not _is_true(data, "first_run.config_created"):
        errors.append("first-run config creation was not confirmed")
    if not _is_true(data, "first_run.audit_dir_writable"):
        errors.append("audit directory writability was not confirmed")
    if not _is_false(data, "first_run.installer_grants_authority"):
        errors.append("installer authority boundary was not confirmed false")
    if not _is_false(data, "first_run.installer_silently_approves_permissions"):
        errors.append("silent approval boundary was not confirmed false")
    if errors:
        return _failed(
            "windows_installer_first_run_smoke",
            "; ".join(errors),
            "Run the Windows installed first-run smoke and record valid release_evidence/windows_installed_smoke.json.",
        )
    return _passed(
        "windows_installer_first_run_smoke",
        "Windows installed executable first-run smoke evidence passed machine validation.",
        "Keep Windows installed first-run evidence current for release candidates.",
    )


def validate_setup_doctor(data: dict[str, Any]) -> EvidenceResult:
    errors: list[str] = []
    setup = _get(data, "setup_doctor")
    if not isinstance(setup, dict):
        errors.append("setup_doctor object missing")
    else:
        if setup.get("status") not in ("pass", "warning"):
            errors.append("setup_doctor.status must be pass or warning")
        if not setup.get("ran_from_installed_app_path"):
            errors.append("Setup Doctor did not run from installed app path")
        if not setup.get("operator_readable"):
            errors.append("Setup Doctor operator readability was not confirmed")
        if setup.get("installer_grants_authority") is not False:
            errors.append("Setup Doctor installer_grants_authority must be false")
        if setup.get("installer_silently_approves_permissions") is not False:
            errors.append("Setup Doctor installer_silently_approves_permissions must be false")
        checks = setup.get("checks")
        if not isinstance(checks, list) or not checks:
            errors.append("Setup Doctor checks must be a non-empty list")
        elif any(check.get("status") == "fail" for check in checks if isinstance(check, dict)):
            errors.append("Setup Doctor contains failing checks")
        elif any(check.get("grants_authority") is not False for check in checks if isinstance(check, dict)):
            errors.append("Setup Doctor check grants authority or lacks grants_authority=false")
    if errors:
        return _failed(
            "windows_setup_doctor_smoke",
            "; ".join(errors),
            "Run Setup Doctor from the installed Windows app path and record valid diagnostics evidence.",
        )
    return _passed(
        "windows_setup_doctor_smoke",
        "Windows installed-path Setup Doctor evidence passed machine validation.",
        "Keep Windows Setup Doctor evidence current for release candidates.",
    )


def validate_windows_release_evidence(path: Path = DEFAULT_EVIDENCE_PATH) -> list[EvidenceResult]:
    data, error = load_evidence(path)
    if data is None:
        return [
            _failed(
                "windows_installer_first_run_smoke",
                error or "Windows installed smoke evidence missing",
                "Create release_evidence/windows_installed_smoke.json from a native Windows installed-app smoke.",
            ),
            _failed(
                "windows_setup_doctor_smoke",
                error or "Windows Setup Doctor evidence missing",
                "Run Setup Doctor from the installed Windows app path and record diagnostics evidence.",
            ),
        ]
    return [validate_installer_first_run(data), validate_setup_doctor(data)]


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--evidence", type=Path, default=DEFAULT_EVIDENCE_PATH)
    args = parser.parse_args()
    results = validate_windows_release_evidence(args.evidence)
    print(json.dumps([result.__dict__ for result in results], indent=2, sort_keys=True))
    return 1 if any(result.classification == "release_blocker" for result in results) else 0


if __name__ == "__main__":
    raise SystemExit(main())
