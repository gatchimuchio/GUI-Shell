import copy


class UpdatePolicyStore:
    def __init__(self):
        self._policies: dict[str, dict] = {}

    def register(self, policy: dict) -> None:
        if policy.get("signature_required") is not True:
            raise ValueError("update policy must require signatures")
        self._policies[policy["policy_id"]] = copy.deepcopy(policy)

    def get(self, policy_id: str) -> dict:
        if policy_id not in self._policies:
            raise KeyError(f"update policy not registered: {policy_id}")
        return copy.deepcopy(self._policies[policy_id])
