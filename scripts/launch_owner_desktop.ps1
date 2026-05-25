$ErrorActionPreference = "Stop"

$Root = Resolve-Path (Join-Path $PSScriptRoot "..")
$Snapshot = Join-Path $Root ".gui_shell\shell_snapshot.json"

Set-Location $Root
python tooling\shell_snapshot.py --write $Snapshot

$env:GUI_SHELL_SNAPSHOT_JSON = $Snapshot
Set-Location (Join-Path $Root "apps\desktop_flutter")
flutter run -d windows
