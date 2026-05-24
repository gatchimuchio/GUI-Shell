import copy

from .policy_evaluator import PolicyEvaluator
from .runtime_state import RuntimeState


class SensitiveActionRouter:
    def __init__(self, state: RuntimeState | None = None):
        self._evaluator = PolicyEvaluator(state) if state is not None else None

    def route(self, action: dict) -> dict:
        required = {
            "capability_id",
            "permission_id",
            "approval_state",
            "audit_event",
            "recovery_action",
        }
        missing = sorted(required - set(action))
        if missing:
            raise ValueError(f"sensitive action missing required mapping: {', '.join(missing)}")
        routed = copy.deepcopy(action)
        if self._evaluator is None:
            routed["routed"] = True
            return routed

        policy_result = self._evaluator.evaluate(routed)
        routed["policy_result"] = policy_result
        routed["routed"] = policy_result["allowed"]
        return routed
