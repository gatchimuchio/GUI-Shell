import copy


def project_approval_content(approval: dict) -> dict:
    visibility = approval["content_visibility"]
    if visibility == "none":
        return {}
    if visibility == "hash_only":
        return {"payload_hash": approval["payload_hash"]}
    if visibility == "summary":
        return {"summary": approval.get("summary", "")}
    if visibility == "redacted":
        return {"redacted_payload": copy.deepcopy(approval.get("redacted_payload", {}))}
    if visibility == "full":
        return {"full_payload": copy.deepcopy(approval.get("full_payload", {}))}
    raise ValueError(f"unknown content visibility: {visibility}")
