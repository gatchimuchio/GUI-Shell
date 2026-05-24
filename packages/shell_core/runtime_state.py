import copy


class RuntimeState:
    def __init__(self):
        self.runtimes: dict[str, dict] = {}
        self.adapters: dict[str, dict] = {}
        self.capabilities: dict[str, dict] = {}
        self.permissions: dict[str, dict] = {}
        self.approvals: dict[str, dict] = {}
        self.audit_events: dict[str, dict] = {}
        self.recovery_actions: dict[str, dict] = {}
        self.update_policies: dict[str, dict] = {}

    def register_runtime(self, runtime: dict) -> None:
        self.runtimes[runtime["runtime_id"]] = copy.deepcopy(runtime)

    def register_adapter(self, adapter: dict) -> None:
        self.adapters[adapter["adapter_id"]] = copy.deepcopy(adapter)

    def register_capability(self, capability: dict) -> None:
        self.capabilities[capability["capability_id"]] = copy.deepcopy(capability)

    def record_permission(self, permission: dict) -> None:
        self.permissions[permission["permission_id"]] = copy.deepcopy(permission)

    def enqueue_approval(self, approval: dict) -> None:
        self.approvals[approval["approval_id"]] = copy.deepcopy(approval)

    def append_audit_event(self, audit_event: dict) -> None:
        self.audit_events[audit_event["event_id"]] = copy.deepcopy(audit_event)

    def register_recovery_action(self, recovery_action: dict) -> None:
        self.recovery_actions[recovery_action["recovery_id"]] = copy.deepcopy(recovery_action)

    def register_update_policy(self, update_policy: dict) -> None:
        self.update_policies[update_policy["policy_id"]] = copy.deepcopy(update_policy)

    def pending_approvals(self) -> list[dict]:
        return [
            copy.deepcopy(self.approvals[key])
            for key in sorted(self.approvals)
            if self.approvals[key].get("status") in {"pending", "requires_validation"}
        ]

    def clone(self) -> "RuntimeState":
        cloned = RuntimeState()
        cloned.runtimes = copy.deepcopy(self.runtimes)
        cloned.adapters = copy.deepcopy(self.adapters)
        cloned.capabilities = copy.deepcopy(self.capabilities)
        cloned.permissions = copy.deepcopy(self.permissions)
        cloned.approvals = copy.deepcopy(self.approvals)
        cloned.audit_events = copy.deepcopy(self.audit_events)
        cloned.recovery_actions = copy.deepcopy(self.recovery_actions)
        cloned.update_policies = copy.deepcopy(self.update_policies)
        return cloned
