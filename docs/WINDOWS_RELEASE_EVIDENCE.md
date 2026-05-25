# Windows Release Evidence

Windows-first release validation uses machine-readable installed-path evidence.

Required evidence file:

```text
release_evidence/windows_installed_smoke.json
```

Generate it on a native Windows host after installing or staging the Windows release artifact:

```powershell
powershell -ExecutionPolicy Bypass -File installer\windows\collect_installed_smoke.ps1 `
  -InstalledExe .\build\windows\x64\runner\Release\gui_shell_desktop.exe `
  -OutputPath release_evidence\windows_installed_smoke.json
```

Then validate:

```powershell
python tooling\windows_release_evidence.py
python tooling\validate_all.py --strict-release --desktop-platform=windows
```

The evidence must prove:

- installed executable exists and has a tagged sha256 hash
- first run launches from the installed app path
- Dashboard, NavigationRail, Runtime Status, and Invariant Status are visible
- first-run config is created
- audit directory is writable
- installer/setup state grants no authority
- installer/setup state silently approves no permissions
- Setup Doctor runs from the installed app path
- Setup Doctor checks are operator-readable and non-authoritative

Do not claim completed product release from copied, edited, or non-Windows evidence. Missing evidence remains a `release_blocker`.
