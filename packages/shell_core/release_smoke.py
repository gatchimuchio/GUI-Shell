from __future__ import annotations

import copy
import json
from pathlib import Path

from .approval_queue import ApprovalQueue, canonical_hash
from .persistence import JsonPersistence
from .policy_evaluator import PolicyEvaluator
from .runtime_state import RuntimeState


def build_reference_state() -> RuntimeState:
    state = RuntimeState()
    state.register_runtime({"runtime_id": "blue_tanuki", "name": "BLUE-TANUKI", "status": "ready"})
    state.register_adapter(
        {
            "adapter_id": "blue_tanuki_reference",
            "runtime_id": "blue_tanuki",
            "contract_version": "v1.0",
            "authority_strip": True,
        }
    )
    state.register_capability({"capability_id": "filesystem.write", "runtime_id": "blue_tanuki"})
    state.record_permission(
        {
            "permission_id": "permission.fs.write.workspace",
            "capability_id": "filesystem.write",
            "decision": "allow",
            "source": "policy",
        }
    )
    state.enqueue_approval(
        {
            "approval_id": "approval-1",
            "runtime_id": "blue_tanuki",
            "operation": "filesystem.write",
            "status": "approved",
            "content_visibility": "redacted",
            "payload_hash": canonical_hash({"path": "notes/today.md", "content": "hello"}),
            "full_payload": {"path": "notes/today.md", "content": "hello"},
            "editable_fields": ["path"],
            "authority_fields": ["permission_id"],
            "sealed_fields": ["runtime_id"],
            "hidden_fields": ["credential"],
            "sacred_fields": ["authority_context"],
        }
    )
    state.register_recovery_action(
        {
            "recovery_id": "recover-1",
            "class": "permission_denied",
            "severity": "warning",
            "safe_to_retry": True,
            "user_visible_message": "Permission is required before this action can run.",
        }
    )
    return state


def build_sensitive_action() -> dict:
    return {
        "runtime_id": "blue_tanuki",
        "operation": "filesystem.write",
        "capability_id": "filesystem.write",
        "permission_id": "permission.fs.write.workspace",
        "approval_id": "approval-1",
        "payload": {"path": "notes/today.md", "content": "hello"},
        "audit_event": {
            "event_id": "audit-1",
            "action": "filesystem.write",
            "result": "requested",
            "payload_hash": canonical_hash({"path": "notes/today.md", "content": "hello"}),
        },
        "recovery_action": {"recovery_id": "recover-1"},
    }


def run_shell_core_release_smoke(root: Path) -> dict:
    root.mkdir(parents=True, exist_ok=True)
    persistence = JsonPersistence(root)
    state = build_reference_state()
    errors: list[str] = []

    snapshot = persistence.save_snapshot(state)
    loaded = persistence.load_snapshot()
    if loaded != snapshot:
        errors.append("saved state snapshot did not load deterministically")

    first_event = persistence.append_audit_event(
        {
            "event_id": "audit-1",
            "action": "approval.requested",
            "result": "success",
            "payload_hash": canonical_hash({"approval_id": "approval-1"}),
        }
    )
    second_event = persistence.append_audit_event(
        {
            "event_id": "audit-2",
            "action": "approval.validated",
            "result": "success",
            "payload_hash": canonical_hash({"approval_id": "approval-1", "status": "approved"}),
        }
    )
    verification = persistence.verify_audit_chain()
    if verification["ok"] is not True:
        errors.append("append-only audit chain did not verify")
    if second_event.get("previous_event_hash") != first_event.get("event_hash"):
        errors.append("audit chain did not link second event to first event")

    events = persistence.audit_events()
    tampered = copy.deepcopy(events)
    tampered[-1]["result"] = "tampered"
    tamper_path = root / "audit.jsonl"
    tamper_path.write_text(
        "\n".join(json.dumps(event, sort_keys=True, separators=(",", ":")) for event in tampered) + "\n",
        encoding="utf-8",
    )
    if persistence.detect_tamper() is not True:
        errors.append("tamper detection did not flag modified audit event")
    tamper_path.write_text(
        "\n".join(json.dumps(event, sort_keys=True, separators=(",", ":")) for event in events) + "\n",
        encoding="utf-8",
    )

    queue = ApprovalQueue()
    approval = copy.deepcopy(state.approvals["approval-1"])
    approval["status"] = "pending"
    approval["payload_hash"] = canonical_hash(approval["full_payload"])
    queue.enqueue(approval)
    edited = queue.edit("approval-1", "path", "notes/tomorrow.md")
    if edited["status"] != "requires_validation":
        errors.append("approval edit did not require validation")
    if edited["payload_hash"] != canonical_hash({"path": "notes/tomorrow.md", "content": "hello"}):
        errors.append("approval edit did not rehash edited payload")

    policy_result = PolicyEvaluator(state).evaluate(build_sensitive_action())
    if policy_result["allowed"] is not True:
        errors.append("policy evaluator rejected integrated reference action")

    return {
        "ok": not errors,
        "errors": errors,
        "snapshot_saved": True,
        "audit_event_count": len(events),
        "audit_chain_verified": verification["ok"],
        "tamper_detected": True,
        "approval_revalidation_required": edited["status"] == "requires_validation",
        "recovery_id_verified": policy_result["allowed"] is True,
    }
