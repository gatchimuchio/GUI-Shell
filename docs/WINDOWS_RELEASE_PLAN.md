# Windows Release Plan

Status date: 2026-05-25

GUI-Shell v1.0 is Windows-first. Linux build and launch smoke are useful development verification, but they are not final product proof by themselves. BLUE-TANUKI remains a consumer/reference runtime and is not a GUI-Shell release dependency.

## Toolchain Requirements

- item: Flutter Windows desktop SDK
  classification: release_blocker
  reason: Windows-side PATH probe found Git but did not find Flutter; Windows Flutter desktop toolchain has not been verified on a Windows host.
  required_action: Run `flutter doctor -v` on Windows and verify Windows desktop support.
  blocks_release: yes

- item: Visual Studio Build Tools
  classification: release_blocker
  reason: Windows desktop builds require Visual Studio desktop C++ build tools, and Windows build smoke has not run on a native Windows host.
  required_action: Install and verify Visual Studio Build Tools for Flutter Windows desktop builds.
  blocks_release: yes

- item: Windows desktop project support
  classification: required_for_v1
  reason: `flutter create --platforms=windows .` generated `apps/desktop_flutter/windows` without overwriting existing `lib/` app code.
  required_action: Keep Windows Flutter desktop project files under version control.
  blocks_release: no

## Validation Commands

- item: Windows Flutter analyze
  classification: release_blocker
  reason: Windows analyze has not passed.
  required_action: Run `cd apps/desktop_flutter && flutter analyze` on Windows.
  blocks_release: yes

- item: Windows Flutter test
  classification: release_blocker
  reason: Windows test has not passed.
  required_action: Run `cd apps/desktop_flutter && flutter test` on Windows.
  blocks_release: yes

- item: Windows build smoke
  classification: release_blocker
  reason: `flutter build windows` was attempted from WSL/Linux and failed with `"build windows" only supported on Windows hosts.`
  required_action: Run `cd apps/desktop_flutter && flutter build windows` on a native Windows host.
  blocks_release: yes

## Launch Smoke Evidence Requirement

- item: Windows launch smoke
  classification: release_blocker
  reason: Windows launch smoke evidence has not been recorded.
  required_action: Launch the Windows build artifact and record first-window evidence showing Dashboard, NavigationRail, Runtime Status, and Invariant Status.
  blocks_release: yes

## Installer And First-Run Requirement

- item: Windows installer and first-run smoke
  classification: release_blocker
  reason: Windows installer and first-run smoke have not passed.
  required_action: Install through the Windows release path, launch from the installed app path, and record first-run evidence.
  blocks_release: yes

- item: Windows Setup Doctor smoke
  classification: release_blocker
  reason: Windows Setup Doctor smoke has not passed from the Windows app path.
  required_action: Run Setup Doctor from the installed Windows app path and record diagnostics evidence.
  blocks_release: yes

## Windows-Specific Failure Modes

- item: PATH resolution
  classification: release_blocker
  reason: Flutter, Git, runtime, or helper commands may resolve differently across PowerShell, CMD, installer environment, and user shell.
  required_action: Validate PATH from the installed app path and Setup Doctor.
  blocks_release: yes

- item: PowerShell policy
  classification: release_blocker
  reason: execution policy can block scripts or helper launch paths.
  required_action: Detect and report policy issues without silently broadening authority.
  blocks_release: yes

- item: Visual Studio Build Tools
  classification: release_blocker
  reason: missing C++ workload or Windows SDK blocks `flutter build windows`.
  required_action: Detect missing build tools and provide operator-visible recovery guidance.
  blocks_release: yes

- item: Windows Defender
  classification: release_blocker
  reason: quarantine or controlled-folder access can block helper, installer, cache, or runtime files.
  required_action: Detect likely Defender interference and classify recovery steps.
  blocks_release: yes

- item: WSL boundary confusion
  classification: release_blocker
  reason: WSL paths and Windows paths can cross authority and filesystem expectations.
  required_action: Keep Windows release validation on native Windows app paths and classify WSL use separately.
  blocks_release: yes

- item: filesystem permission
  classification: release_blocker
  reason: Program Files, user profile, temp, and workspace permissions can differ.
  required_action: Validate filesystem diagnostics through Shell Core permission, approval, audit, and recovery mapping.
  blocks_release: yes

- item: Git credential / SSH credential confusion
  classification: release_blocker
  reason: Windows Credential Manager, SSH agent, Git config, and WSL credentials can diverge.
  required_action: Detect credential-surface ambiguity without exposing secrets or treating credentials as authority.
  blocks_release: yes
