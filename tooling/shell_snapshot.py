from __future__ import annotations

import argparse
import json
import sys
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT))

from installer.setup_doctor import setup_doctor_report
from packages.shell_core.invariant_evaluator import InvariantEvaluator
from packages.shell_core.release_smoke import build_reference_state


DEFAULT_SNAPSHOT_PATH = ROOT / ".gui-shell" / "shell_snapshot.json"


def build_shell_snapshot() -> dict:
    state = build_reference_state()
    setup = setup_doctor_report()
    invariant_flags = InvariantEvaluator().evaluate()
    runtimes = [
        {
            "runtime_id": runtime_id,
            "name": runtime.get("name", runtime_id),
            "status": runtime.get("status", "unknown"),
            "adapter_id": _adapter_for_runtime(state.adapters, runtime_id),
            "diagnostic_summary": "reference runtime contract available",
        }
        for runtime_id, runtime in sorted(state.runtimes.items())
    ]
    permissions = [
        {
            "permission_id": permission_id,
            "capability_id": permission.get("capability_id", ""),
            "decision": permission.get("decision", "unknown"),
            "source": permission.get("source", "unknown"),
            "expires_at": permission.get("expires_at"),
        }
        for permission_id, permission in sorted(state.permissions.items())
    ]
    approvals = [
        {
            "approval_id": approval_id,
            "operation": approval.get("operation", ""),
            "status": approval.get("status", "unknown"),
            "content_visibility": approval.get("content_visibility", "redacted"),
            "projected_content": _projected_content(approval),
            "editable_fields": approval.get("editable_fields", []),
            "protected_fields": sorted(
                set(approval.get("authority_fields", []))
                | set(approval.get("sealed_fields", []))
                | set(approval.get("hidden_fields", []))
                | set(approval.get("sacred_fields", []))
                | {"payload_hash"}
            ),
        }
        for approval_id, approval in sorted(state.approvals.items())
    ]
    audit_events = [
        {
            "event_id": "audit-1",
            "action": "approval.requested",
            "result": "success",
            "payload_hash": "sha256:" + "2" * 64,
            "previous_event_hash": None,
        }
    ]
    recovery_actions = [
        {
            "recovery_id": recovery_id,
            "severity": recovery.get("severity", "warning"),
            "message": recovery.get("user_visible_message", ""),
            "safe_to_retry": recovery.get("safe_to_retry", False),
        }
        for recovery_id, recovery in sorted(state.recovery_actions.items())
    ]
    return {
        "runtimes": runtimes,
        "agent_sessions": [
            {
                "session_id": "agent-session-reference",
                "workspace": "/workspace/project",
                "task": "Validate GUI-Shell release evidence",
                "changed_files": ["VALIDATION.txt", "docs/GUI_OPERATION_SURFACES.md"],
                "tool_calls": ["schema_check", "conformance", "release_smoke"],
                "shell_commands": ["python3 tooling/validate_all.py"],
                "test_status": "development validation passed",
                "diff_summary": "operation surfaces and evidence paths available",
                "pending_approval_count": len(approvals),
                "rollback_candidate": "recover-1",
                "audit_event_id": "audit-1",
            }
        ],
        "permissions": permissions,
        "pending_approvals": approvals,
        "audit_events": audit_events,
        "recovery_actions": recovery_actions,
        "invariant_flags": invariant_flags,
        "setup_doctor_checks": setup["checks"],
        "setup_doctor_status": setup["status"],
        "installer_grants_authority": setup["installer_grants_authority"],
        "installer_silently_approves_permissions": setup["installer_silently_approves_permissions"],
        "trust_records": _trust_records(),
        "authority_map": _authority_map(state, approvals, audit_events, recovery_actions),
        "adapter_catalog": _adapter_catalog(state),
        "permission_diffs": _permission_diffs(),
        "problems": _problems(),
        "evidence": _evidence_records(),
        "settings": _settings_records(),
        "audit_chain_status": "verified",
        "network_exposure": "localhost only",
        "release_blocker_count": 1,
    }


def _adapter_for_runtime(adapters: dict, runtime_id: str) -> str:
    for adapter_id, adapter in sorted(adapters.items()):
        if adapter.get("runtime_id") == runtime_id:
            return adapter_id
    return ""


def _projected_content(approval: dict) -> dict:
    if approval.get("content_visibility") == "full":
        return dict(approval.get("full_payload", {}))
    payload = approval.get("full_payload", {})
    if isinstance(payload, dict) and "path" in payload:
        return {"path": payload["path"], "content": "[redacted]"}
    return {"summary": "[redacted]"}


def _trust_records() -> list[dict]:
    return [
        {
            "scope": "workspace_trust",
            "state": "restricted",
            "source": "local policy",
            "expires_at": None,
            "blocked_operations": ["process.spawn", "network.public_bind"],
        },
        {
            "scope": "runtime_trust",
            "state": "trusted",
            "source": "signed manifest",
            "expires_at": None,
            "blocked_operations": [],
        },
        {
            "scope": "adapter_trust",
            "state": "inherited",
            "source": "runtime_trust",
            "expires_at": None,
            "blocked_operations": [],
        },
        {
            "scope": "installer_trust",
            "state": "unknown",
            "source": "installed-path evidence missing",
            "expires_at": None,
            "blocked_operations": ["release_ready_claim"],
        },
    ]


def _authority_map(state, approvals: list[dict], audit_events: list[dict], recovery_actions: list[dict]) -> list[dict]:
    rows = []
    approval_id = approvals[0]["approval_id"] if approvals else ""
    audit_id = audit_events[0]["event_id"] if audit_events else ""
    recovery_id = recovery_actions[0]["recovery_id"] if recovery_actions else ""
    for permission_id, permission in sorted(state.permissions.items()):
        capability_id = permission.get("capability_id", "")
        capability = state.capabilities.get(capability_id, {})
        rows.append(
            {
                "runtime_id": capability.get("runtime_id", ""),
                "capability_id": capability_id,
                "permission_id": permission_id,
                "approval_id": approval_id,
                "audit_event_id": audit_id,
                "recovery_id": recovery_id,
                "dangerous": capability_id in {"process.spawn", "network.public_bind"},
                "warning": "" if permission.get("decision") in {"allow", "approved"} else "permission not granted",
            }
        )
    return rows


def _adapter_catalog(state) -> list[dict]:
    return [
        {
            "adapter_id": adapter_id,
            "runtime_id": adapter.get("runtime_id", ""),
            "publisher": "GUI-Shell reference",
            "version": adapter.get("contract_version", "unknown"),
            "signature": "development",
            "hash": "sha256:pending",
            "requested_capabilities": list(adapter.get("declared_capabilities", [])),
            "granted_capabilities": [],
            "denied_capabilities": ["network.public_bind"],
            "trust_status": "inherited",
            "last_verified": "release_smoke",
            "update_available": False,
            "known_risks": ["reference adapter only"],
        }
        for adapter_id, adapter in sorted(state.adapters.items())
    ]


def _permission_diffs() -> list[dict]:
    return [
        {
            "subject": "blue_tanuki_reference",
            "added": ["filesystem.write"],
            "removed": [],
            "changed": ["content_visibility: full -> redacted"],
            "dangerous": [],
        }
    ]


def _problems() -> list[dict]:
    return [
        {
            "problem_id": "windows-installed-evidence-missing",
            "severity": "blocked",
            "category": "missing_evidence",
            "message": "Windows installed-path evidence is missing.",
            "target": "release_evidence/windows_installed_smoke.json",
            "recovery_id": "recover-windows-evidence",
        }
    ]


def _evidence_records() -> list[dict]:
    return [
        {
            "evidence_id": "windows-installed-smoke",
            "kind": "installed-path",
            "status": "missing",
            "path": "release_evidence/windows_installed_smoke.json",
            "hash": "",
            "exportable": False,
        },
        {
            "evidence_id": "development-validation",
            "kind": "validation",
            "status": "passed",
            "path": "tooling/validate_all.py",
            "hash": "",
            "exportable": True,
        },
    ]


def _settings_records() -> list[dict]:
    return [
        {
            "key": "content_visibility.default",
            "group": "authority",
            "default": "redacted",
            "current": "redacted",
            "effective": "redacted",
            "source": "Shell Core policy",
            "modified": False,
            "dangerous": False,
            "authority_related": True,
        },
        {
            "key": "network.public_bind",
            "group": "runtime",
            "default": "blocked",
            "current": "blocked",
            "effective": "blocked",
            "source": "permission ledger",
            "modified": False,
            "dangerous": True,
            "authority_related": True,
        },
    ]


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--output", type=Path)
    args = parser.parse_args()
    snapshot = build_shell_snapshot()
    encoded = json.dumps(snapshot, indent=2, sort_keys=True)
    if args.output:
        args.output.parent.mkdir(parents=True, exist_ok=True)
        args.output.write_text(encoded + "\n", encoding="utf-8")
    else:
        print(encoded)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
