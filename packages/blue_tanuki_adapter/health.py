def health() -> dict:
    return {
        "runtime_id": "blue_tanuki",
        "status": "ready",
        "message": "reference runtime mock health is ready",
    }


def ready() -> dict:
    return {
        "runtime_id": "blue_tanuki",
        "ready": True,
    }
