def audit_events() -> list[dict]:
    return [
        {
            "event_id": "blue-tanuki-adapter-audit-1",
            "timestamp": "2026-05-25T00:00:00Z",
            "actor": "adapter",
            "action": "runtime.snapshot",
            "target": "blue_tanuki",
            "result": "success",
            "payload_hash": "sha256:4444444444444444444444444444444444444444444444444444444444444444",
            "previous_event_hash": None,
            "metadata": {
                "adapter_id": "blue_tanuki_reference",
            },
        }
    ]
