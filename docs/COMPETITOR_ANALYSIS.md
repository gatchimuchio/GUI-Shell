# Competitor Analysis

Sources reviewed:

- Docker Desktop documentation: https://docs.docker.com/desktop/
- AnythingLLM Desktop documentation: https://docs.anythingllm.com/installation-desktop/overview
- OpenHands quick start documentation: https://docs.openhands.dev/overview/quickstart
- LM Studio documentation: https://lmstudio.ai/docs
- Open WebUI documentation: https://docs.openwebui.com/
- Ollama documentation: https://docs.ollama.com/
- AIDev paper: https://arxiv.org/abs/2602.09185

## Classified Requirements

- requirement: Desktop GUI hides lower-level runtime complexity while exposing install, settings, logs, troubleshooting, backup, security, and AI/agent surfaces.
  source/competitor: Docker Desktop
  implementation target: Dashboard, Setup Doctor, Runtime Center, Agent Center, Audit Viewer, Recovery Center
  classification: required_for_v1
  blocks_release: yes

- requirement: Single-user local-first desktop product with low-friction install path.
  source/competitor: AnythingLLM Desktop
  implementation target: Desktop app plus installer first-run flow
  classification: required_for_v1
  blocks_release: yes

- requirement: Local GUI and environment control without forcing normal users through Docker/CLI setup.
  source/competitor: OpenHands
  implementation target: Setup Doctor and installer recovery actions
  classification: required_for_v1
  blocks_release: yes

- requirement: Runtime manifests and adapter manifests for local LLM runtimes.
  source/competitor: LM Studio, Open WebUI, Ollama
  implementation target: Runtime Catalog
  classification: required_for_v1
  blocks_release: yes

- requirement: Agent sessions, tasks, workspaces, tool calls, diffs, commits, approvals, and audit logs as first-class contracts.
  source/competitor: Codex-like coding agents and AIDev paper
  implementation target: Agent Runtime Contract
  classification: required_for_v1
  blocks_release: yes

- requirement: Live integrations for all major coding agents.
  source/competitor: Codex, Claude Code, Copilot, Cursor, Devin, OpenHands
  implementation target: adapter packages
  classification: post_v1_scope
  reason: v1.0 requires generic Agent Runtime contract and mock/reference agent.
  blocks_release: no

- requirement: Cloud sync and multi-user administration.
  source/competitor: broader runtime management products
  implementation target: post-v1 service layer
  classification: post_v1_scope
  reason: v1.0 is desktop-first, local-first, single-user.
  blocks_release: no

- requirement: Only local single-user mode in v1.0.
  source/competitor: AnythingLLM Desktop positioning
  implementation target: README, CLAIM, installer, Shell Core assumptions
  classification: known_limitation
  reason: deliberate v1.0 scope.
  blocks_release: no
