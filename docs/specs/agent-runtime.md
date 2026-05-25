# Agent Runtime Contract

Agent runtimes are first-class runtime types. They must be controlled by Shell Core permission, approval, audit, and recovery semantics.

Core records:

- AgentRuntime
- AgentSession
- AgentTask
- AgentWorkspace
- AgentToolCall
- AgentPermissionRequest
- AgentDiff
- AgentCommit
- AgentPullRequest
- AgentRunLog

Conformance requirements:

- workspace-external access is default deny
- secret path read is default deny
- shell command requires permission mapping
- git push requires explicit approval
- generated diff requires audit evidence
- agent auto-permission mode is advisory only
- rollback candidate is required for state-changing actions
