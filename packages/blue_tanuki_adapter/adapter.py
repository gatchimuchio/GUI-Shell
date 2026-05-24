from .approvals import normalize_approval
from .audit_export import audit_events
from .authority_trace import authority_trace
from .diagnostics import diagnostics_export
from .health import health, ready
from .notifications import notifications
from .recovery import recovery_candidates
from .runtime_snapshot import runtime_snapshot


class BlueTanukiAdapter:
    def health(self) -> dict:
        return health()

    def ready(self) -> dict:
        return ready()

    def runtime_snapshot(self) -> dict:
        return runtime_snapshot()

    def authority_trace(self) -> dict:
        return authority_trace()

    def notifications(self) -> list[dict]:
        return notifications()

    def approvals(self) -> list[dict]:
        return [normalize_approval({})]

    def audit_events(self) -> list[dict]:
        return audit_events()

    def diagnostics_export(self) -> dict:
        return diagnostics_export()

    def recovery_actions(self) -> list[dict]:
        return recovery_candidates("runtime_down")
