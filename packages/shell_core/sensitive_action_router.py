import copy


class SensitiveActionRouter:
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
        routed["routed"] = True
        return routed
