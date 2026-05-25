import copy
import json
from pathlib import Path

from .runtime_state import RuntimeState
from .state_snapshot import create_state_snapshot


def save_snapshot(state: RuntimeState, path: Path) -> dict:
    snapshot = create_state_snapshot(state)
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(snapshot, sort_keys=True, indent=2), encoding="utf-8")
    return copy.deepcopy(snapshot)


def load_snapshot(path: Path) -> dict:
    return json.loads(path.read_text(encoding="utf-8"))
