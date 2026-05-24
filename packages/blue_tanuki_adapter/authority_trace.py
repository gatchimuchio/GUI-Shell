AUTHORITY_KEYS = {
    "authority",
    "authority_context",
    "authority_fields",
    "approval_state",
    "capability_grants",
    "grants",
    "permission",
    "permissions",
    "privileges",
    "role",
    "trust_level",
}


def metadata_attempts_authority(metadata: dict) -> bool:
    for key, value in metadata.items():
        if key in AUTHORITY_KEYS:
            return True
        if isinstance(value, dict) and metadata_attempts_authority(value):
            return True
    return False


def authority_trace() -> dict:
    return {
        "runtime_id": "blue_tanuki",
        "adapter_id": "blue_tanuki_reference",
        "metadata_trusted": False,
        "adapter_can_grant_permission": False,
        "adapter_can_approve": False,
        "authority_source": "shell_core",
    }
