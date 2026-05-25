# Competitor Analysis

Sources reviewed:

- Docker Desktop documentation: https://docs.docker.com/desktop/
- AnythingLLM Desktop documentation: https://docs.anythingllm.com/installation-desktop/overview
- OpenHands quick start documentation: https://docs.openhands.dev/overview/quickstart
- LM Studio documentation: https://lmstudio.ai/docs
- Open WebUI documentation: https://docs.openwebui.com/
- Ollama documentation: https://docs.ollama.com/
- AIDev paper: https://arxiv.org/abs/2602.09185

## Findings

Docker Desktop establishes the benchmark for a GUI that hides lower-level runtime complexity while still exposing install, settings, images/containers/logs, troubleshooting, backup, security, AI/agents, MCP, and model-runner surfaces. GUI-Shell should mirror that operational breadth for AI runtimes and agents while preserving permission, approval, audit, and recovery boundaries.

AnythingLLM Desktop demonstrates the value of a single-user, local-first desktop product with a low-friction install path. GUI-Shell v1.0 should optimize for the same product shape: a complete desktop app for one local operator, not a multi-user cloud control plane.

OpenHands separates cloud, terminal, and local GUI usage. GUI-Shell should take the local GUI and environment-control lesson, but reduce Docker/CLI setup burden through Setup Doctor and installer flow.

LM Studio, Open WebUI, and Ollama show that local model runtimes expose a mix of desktop, web UI, API, model management, localhost binding, and offline operation. GUI-Shell should not hard-code these runtimes; it needs runtime manifests and adapter manifests.

Codex-like coding agents are now a major runtime category. GUI-Shell must model agent sessions, tasks, workspaces, tool calls, diffs, commits, approvals, and audit logs as first-class contracts.

## Implementation Requirements

- Desktop-first single-user product scope.
- Runtime Catalog based on signed manifests.
- Agent Runtime Contract independent of any one agent vendor.
- Setup Doctor checks for tools, ports, bind addresses, filesystem permissions, audit storage, workspace boundary, and secret path policy.
- Agent Center in desktop UI.
- Shell Core persistence using append-only JSONL and deterministic snapshots before DB complexity.
- Audit chain verification and tamper detection.
- Release gate must require actual Cargo and Flutter validation, not skeleton-only claims.
