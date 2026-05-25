# GUI-Shell Strategy

GUI-Shell v1.0 is a desktop-first, single-user, local-first AI Runtime / Agent Operation Shell.

BLUE-TANUKI is a consumer and dogfooding runtime for GUI-Shell. It is not a GUI-Shell v1.0 dependency or release gate.

## Product Definition

GUI-Shell v1.0 provides:

- desktop operator app
- installer and first-run Setup Doctor
- runtime catalog
- agent runtime contract
- permission, approval, audit, and recovery control plane
- Shell Core persistence
- append-only audit chain verification
- adapter contract for arbitrary runtimes and agents

## Why GUI-Shell Precedes BLUE-TANUKI Completion

GUI-Shell owns the generic operation surface: runtime discovery, permission visibility, approval workflow, audit evidence, recovery guidance, and first-run diagnostics. BLUE-TANUKI should consume those surfaces through adapter contracts rather than shape Shell Core.

Completing BLUE-TANUKI first would bias GUI-Shell toward one runtime. Completing GUI-Shell first keeps runtime and agent operation generic enough for Ollama, LM Studio, Open WebUI, Codex-like agents, and BLUE-TANUKI.

## Desktop-First Release Scope

v1.0 includes:

- Desktop Flutter app
- Setup Doctor
- Runtime Center
- Agent Center
- Permission Center
- Approval Center
- Audit Viewer
- Recovery Center
- Settings
- mock/reference runtime
- mock/reference agent

v1.0 excludes:

- mobile completion
- multi-user
- cloud service
- runtime marketplace
- BLUE-TANUKI product completion
- all live coding-agent adapters
- enterprise admin

## Post-v1.0 Scope

Post-v1.0 work may add mobile, multi-user, cloud sync, marketplace distribution, live BLUE-TANUKI integration, and live Codex/Claude/Copilot adapters after the desktop single-user control plane is complete.
