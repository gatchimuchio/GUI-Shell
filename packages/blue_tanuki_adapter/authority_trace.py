from packages.shell_core.normalization import authority_keys_in, authority_values_in, strip_authority_keys


def metadata_attempts_authority(metadata: dict) -> bool:
    stripped = strip_authority_keys(metadata)
    return bool(authority_keys_in(metadata) or authority_values_in(stripped))


def authority_trace() -> dict:
    return {
        "runtime_id": "blue_tanuki",
        "adapter_id": "blue_tanuki_reference",
        "metadata_trusted": False,
        "adapter_can_grant_permission": False,
        "adapter_can_approve": False,
        "authority_source": "shell_core",
    }
