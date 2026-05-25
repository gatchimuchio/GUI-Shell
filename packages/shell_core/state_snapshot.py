import copy
import json

from .runtime_state import RuntimeState
from .invariant_evaluator import InvariantEvaluator


def _sorted_values(values: dict[str, dict], key_name: str) -> list[dict]:
    return [copy.deepcopy(values[key]) for key in sorted(values, key=lambda item: values[item].get(key_name, item))]


def create_state_snapshot(state: RuntimeState) -> dict:
    audit_events = _sorted_values(state.audit_events, "event_id")
    recovery_actions = _sorted_values(state.recovery_actions, "recovery_id")
    update_policies = _sorted_values(state.update_policies, "policy_id")

    return {
        "runtimes": _sorted_values(state.runtimes, "runtime_id"),
        "adapters": _sorted_values(state.adapters, "adapter_id"),
        "permissions": _sorted_values(state.permissions, "permission_id"),
        "pending_approvals": state.pending_approvals(),
        "audit_summary": {
            "event_count": len(audit_events),
            "event_ids": [event["event_id"] for event in audit_events],
            "latest_event_hash": audit_events[-1].get("event_hash") if audit_events else None,
        },
        "recovery_catalog_summary": {
            "action_count": len(recovery_actions),
            "recovery_ids": [action["recovery_id"] for action in recovery_actions],
        },
        "update_policy_summary": {
            "policy_count": len(update_policies),
            "policy_ids": [policy["policy_id"] for policy in update_policies],
            "signature_required": all(policy.get("signature_required") is True for policy in update_policies),
        },
        "invariant_flags": InvariantEvaluator().evaluate(),
    }


def deterministic_snapshot_json(state: RuntimeState) -> str:
    return json.dumps(create_state_snapshot(state), sort_keys=True, separators=(",", ":"))
