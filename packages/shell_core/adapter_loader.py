from .normalization import authority_values_in, strip_authority_keys


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
        if authority_values_in(self.metadata):
            raise ValueError("adapter metadata contains authority-like values")

    def effective_capabilities(self) -> tuple[str, ...]:
        return self.declared_capabilities


def load_adapter(adapter: dict) -> AdapterRecord:
    return AdapterRecord(adapter)
