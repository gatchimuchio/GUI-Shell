#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SNAPSHOT="$ROOT/.gui_shell/shell_snapshot.json"

cd "$ROOT"
python3 tooling/shell_snapshot.py --write "$SNAPSHOT"

export GUI_SHELL_SNAPSHOT_JSON="$SNAPSHOT"
cd apps/desktop_flutter
flutter run -d linux
