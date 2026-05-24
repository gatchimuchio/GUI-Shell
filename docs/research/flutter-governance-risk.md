# Flutter Governance Risk Register

Status: Active watch item

## Risk

Flutter is Google-led and may be affected by:

- organizational restructuring
- priority changes
- desktop deprioritization
- Dart/Flutter team resourcing changes
- ecosystem slowdown

## Impact

Potential impact areas:

- desktop support quality
- tooling quality
- platform channel stability
- package ecosystem health
- issue resolution speed

## Mitigation

- Keep core schemas framework-independent.
- Keep Rust helper outside Flutter.
- Keep Adapter Contract outside Flutter.
- Limit Dart to UI layer.
- Maintain conformance tests independent of Flutter.
- Re-evaluate every 6 months through `FrameworkRiskProfile`.

## Exit signals

- desktop support materially degrades
- official roadmap deprioritizes desktop
- critical Flutter-originated GUI Shell bug becomes unavoidable
- ecosystem health declines enough to block stable product delivery
