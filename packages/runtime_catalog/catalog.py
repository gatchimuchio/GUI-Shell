import copy

from packages.shell_core.authority_keys import AUTHORITY_KEYS


class RuntimeCatalog:
    def __init__(self):
        self._runtimes: dict[str, dict] = {}
        self._adapters: dict[str, dict] = {}

    def register_runtime_manifest(self, manifest: dict) -> None:
        if manifest.get("signed_manifest") is not True:
            raise ValueError("runtime manifest must be signed")
        self._runtimes[manifest["runtime_id"]] = copy.deepcopy(manifest)

    def register_adapter_manifest(self, manifest: dict) -> None:
        if manifest.get("authority_strip") is not True:
            raise ValueError("adapter manifest must require authority_strip=true")
        if manifest.get("signed_manifest") is not True:
            raise ValueError("adapter manifest must be signed")
        self._adapters[manifest["adapter_id"]] = copy.deepcopy(manifest)

    def runtime_manifests(self) -> list[dict]:
        return [copy.deepcopy(self._runtimes[key]) for key in sorted(self._runtimes)]

    def adapter_manifests(self) -> list[dict]:
        return [copy.deepcopy(self._adapters[key]) for key in sorted(self._adapters)]

    def can_grant_authority(self, manifest: dict) -> bool:
        return False

    def metadata_attempts_authority(self, metadata: dict) -> bool:
        return self._contains_authority_key(metadata)

    def _contains_authority_key(self, value) -> bool:
        if isinstance(value, dict):
            return any(key in AUTHORITY_KEYS or self._contains_authority_key(item) for key, item in value.items())
        if isinstance(value, list):
            return any(self._contains_authority_key(item) for item in value)
        return False
