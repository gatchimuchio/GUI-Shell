import copy

from .authority_keys import AUTHORITY_KEYS


class AdapterRecord:
    def __init__(self, adapter: dict):
        if adapter.get("authority_strip") is not True:
            raise ValueError("adapter must declare authority_strip=true")
        self.adapter_id = adapter["adapter_id"]
        self.runtime_id = adapter["runtime_id"]
        self.contract_version = adapter["contract_version"]
        self.transport = adapter.get("transport", "mock")
        self.declared_capabilities = tuple(adapter.get("declared_capabilities", []))
        self.metadata = strip_authority_keys(adapter.get("metadata", {}))

    def effective_capabilities(self) -> tuple[str, ...]:
        return self.declared_capabilities


def strip_authority_keys(value):
    if isinstance(value, dict):
        return {
            key: strip_authority_keys(item)
            for key, item in value.items()
            if key not in AUTHORITY_KEYS
        }
    if isinstance(value, list):
        return [strip_authority_keys(item) for item in value]
    return value


def load_adapter(adapter: dict) -> AdapterRecord:
    return AdapterRecord(adapter)
