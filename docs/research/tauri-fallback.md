# Tauri Fallback

Status: watchlist / desktop-heavy fallback  
Primary candidate remains: Flutter + Rust helper  
Fallback trigger: Flutter desktop viability materially degrades or strategy becomes desktop-heavy

## Position

Tauri is not the primary GUI Shell implementation candidate.

It remains a fallback for a desktop-heavy direction because it provides:

- Rust backend alignment;
- explicit capability-style thinking;
- smaller desktop footprint than Electron;
- strong fit for local desktop host surfaces.

## Why not primary

GUI Shell treats PC and mobile as equally important.

Tauri is weaker than Flutter for the current target because:

- mobile parity requires more validation;
- WebView / JavaScript / native bridge audit burden is high;
- UI consistency across desktop and mobile is less direct;
- Shell Core contracts must remain framework-independent either way.

## Re-evaluation triggers

Re-evaluate Tauri if:

- GUI Shell strategy changes to desktop host first;
- mobile becomes companion-only;
- Flutter desktop support materially degrades;
- Flutter tooling or package ecosystem becomes unsuitable;
- TypeScript asset reuse becomes more important than unified Flutter UI.

## Boundary rule

If Tauri is adopted later, it remains a UI/runtime host layer only.

The following assets must not move into Tauri-specific code:

- JSON Schemas;
- Adapter Contract;
- Permission model;
- Approval model;
- AuditEvent model;
- RecoveryAction model;
- Content Exposure Boundary;
- Authority Strip Conformance;
- Shell Core authority decisions.
