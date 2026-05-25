from pathlib import Path


SECRET_PATH_PARTS = {".env", ".ssh", ".gnupg", "secrets"}


class AgentRuntimeContract:
    def __init__(self, workspace: dict):
        self.workspace = dict(workspace)
        self.root_path = Path(workspace["root_path"]).resolve()
        self.secret_paths = tuple(workspace.get("secret_paths", []))

    def path_allowed(self, candidate: str) -> bool:
        path = Path(candidate).resolve()
        try:
            path.relative_to(self.root_path)
        except ValueError:
            return False
        return not self.is_secret_path(candidate)

    def is_secret_path(self, candidate: str) -> bool:
        parts = set(Path(candidate).parts)
        return bool(parts & SECRET_PATH_PARTS) or any(secret in candidate for secret in self.secret_paths)

    def shell_command_requires_permission(self, tool_call: dict) -> bool:
        return tool_call.get("tool_name") == "shell.command" and bool(tool_call.get("permission_id"))

    def git_push_requires_explicit_approval(self, tool_call: dict) -> bool:
        if tool_call.get("tool_name") != "git.push":
            return True
        return tool_call.get("approval_required") is True and bool(tool_call.get("permission_id"))

    def diff_is_auditable(self, diff: dict) -> bool:
        return bool(diff.get("audit_event_id")) and bool(diff.get("payload_hash"))

    def auto_permission_is_advisory_only(self, runtime: dict) -> bool:
        return runtime.get("auto_permission_mode") in {"disabled", "advisory_only"}

    def state_change_has_rollback(self, record: dict) -> bool:
        return bool(record.get("rollback_candidate_id"))
