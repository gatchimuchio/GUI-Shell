# GUI Shell 技術選定・設計方針レポート v0.3.1 Phase 0 Lock

Status: Phase 0 Lock  
Scope: GUI Shell / Cross-device Runtime Operation Shell  
Primary decision: Flutter + Rust helper, with explicit governance/stability risk register  
Reference runtime: BLUE-TANUKI  
Important note: BLUE-TANUKI implementation is frozen. GUI Shell is designed as a generic shell from the beginning.

---

## 0. Executive Summary

```text
GUI Shellは、BLUE-TANUKI専用GUIではない。
最初から汎用Runtime Operation Shellとして設計する。

実装第一候補は Flutter + Rust helper。
ただし、Flutterは「唯一のベスト」ではなく、現条件下のベター選択である。

安定性を独立軸に追加すると、Flutterの単純優位は崩れる。
Compose Multiplatform / Kotlin は、開発元継続性・Kotlin地盤では強い。
一方で、iOS stable化が新しく、枯れ具合・production実績ではFlutterが上回る。

したがって、GUI ShellではFlutterを採用候補第一としつつ、
Flutter governance risk、desktop優先度低下リスク、撤退・移行条件をPhase 0で明記する。
```

最終判断:

```text
採用第一候補:
  Flutter + Rust helper

対抗候補:
  Compose Multiplatform + Kotlin + Rust helper

保留候補:
  Tauri + TypeScript + Rust

採用しない:
  Electron単独
  React Native単独
```

確信度: **70%**  
この70%は「Flutter + Rust helper を今選ぶこと」の妥当性である。  
「GUI Shellを汎用Shellとして設計すること」自体の確信度は **95%** とする。

---

## 1. 前提条件

### 1.1 BLUE-TANUKIの扱い

BLUE-TANUKIは凍結する。

```text
- GUI Shellの都合でBLUE-TANUKI Coreを大きく作り替えない。
- GUI ShellはBLUE-TANUKI Adapter経由で接続する。
- BLUE-TANUKI固有概念をGUI Shell Coreへ混入しない。
- BLUE-TANUKIはReference Runtimeとして扱う。
```

### 1.2 GUI Shellの目的

```text
複数のRuntime / Agent / Tool / Local Serviceを対象に、
導入・起動・状態監視・権限・承認・監査・復旧・更新・端末連携を、
一体のユーザー体験として提供する汎用アプリ体験制御基盤を作る。
```

### 1.3 絶対要件

```text
- 最初から汎用設計
- BLUE-TANUKI専用MVPにしない
- インストーラ完了 → アプリ起動 → 体験開始
- 低レイヤーをユーザーに押し付けない
- PCとスマホは同じ重要度で扱う
- PCから着手するが、PC重心ではない
- Mobileは将来規定事項
- 安全性・堅牢性・安定性を主要選定軸にする
```

---

## 2. 評価軸の再定義

v0.2では、安全性・堅牢性・PC/スマホ同格性を中心に評価した。  
v0.3以降では、**安定性**を独立軸として追加する。

### 2.1 安全性

危険操作・権限・承認・監査・秘密情報・外部入力に対して、事故を起こしにくい構造を持つか。

```text
- default deny
- Capability / Permission
- Approval
- Audit
- Content exposure boundary
- Authority strip
- Native bridge境界
- Runtime隔離
```

### 2.2 堅牢性

実行時に壊れにくいか。

```text
- クラッシュ耐性
- 長時間稼働
- UI描画の一貫性
- OS差異吸収
- Recovery可能性
- Runtime状態管理
```

### 2.3 安定性

基盤そのものが長期的に揺らがないか。堅牢性とは別軸。

```text
1. API / 後方互換の安定
2. 開発元・エコシステムの継続性
3. 枯れ具合・production実績
4. Desktop / Mobile双方への継続投資
5. 放棄・縮小・優先度低下リスク
```

---

## 3. Flutterの評価

### 3.1 強み

```text
- PC / Android / iOS / Webを同一UI思想で扱いやすい。
- Mobileが本線に入っている。
- UI一貫性が高い。
- production実績が厚い。
- 開発者人口・資料・package ecosystemが大きい。
- GUI Shellの承認、権限、復旧、設定UIを統一しやすい。
```

### 3.2 弱み

```text
- Google依存が強い。
- Flutter / Dart teamへのレイオフ報道があった。
- Googleの過去プロジェクト終了実績による構造的不信がある。
- Desktop領域の優先度低下リスクが懸念される。
- Dart導入により言語が増える。
- 危険OS操作は結局Rust helper等へ逃がす必要がある。
```

### 3.3 安定性評価

```text
Flutter安定性:
  API/production実績: 強い
  開発元継続性: 中程度
  Desktop継続投資: 要監視
  放棄リスク: 低〜中。ただしGoogle依存として明記必須
```

---

## 4. Compose Multiplatform / Kotlinの評価

### 4.1 強み

```text
- JetBrainsが開発元であり、IDE事業を中心とした堅実な収益基盤を持つ。
- KotlinはAndroid公式言語として強い地盤を持つ。
- GoogleもAndroid/Kotlinを公式支援している。
- Compose MultiplatformはAndroid / iOS / Desktop / Webを対象にしている。
- UIもbusiness logicもKotlin側に寄せられる。
- 長期継続性ではFlutterより構造的に安心感がある。
```

### 4.2 弱み

```text
- iOS stable化が新しい。
- Flutterに比べるとproduction実績・枯れ具合が浅い。
- GUI Shellの規模で採用した場合、初期のAPI調整リスクがある。
- Flutterほど広い実装知見・事例がまだ蓄積されていない。
```

### 4.3 安定性評価

```text
Compose MP安定性:
  API/production実績: 新しいため中〜弱
  開発元継続性: 強い
  Desktop継続投資: 強め
  Mobile iOS実績: これから
```

---

## 5. Flutter vs Compose Multiplatform

| 評価軸 | Flutter + Rust helper | Compose MP + Rust helper |
|---|---:|---:|
| 安全性 | ○ | ○ |
| 堅牢性 | ◎ | ○ |
| PC/スマホ同格性 | ◎ | ○〜◎ |
| production実績 | ◎ | △〜○ |
| API/枯れ具合 | ◎ | △ |
| 開発元継続性 | △〜○ | ○〜◎ |
| Desktop継続性 | △〜○ | ○ |
| Mobile成熟度 | ◎ | ○ |
| 言語負荷 | Dart追加 | Kotlin追加 |
| BLUE-TANUKI接続性 | ○（Adapter契約により原則framework非依存） | ○（Adapter契約により原則framework非依存） |
| 長期安定性 | ○ | ○〜◎ |

### 5.1 要点

```text
Flutter:
  枯れた実績とUI一貫性を取る選択。

Compose MP:
  開発元継続性とKotlin地盤を取る選択。
```

### 5.2 修正理由

v0.3.1では以下を調整した。

```text
- BLUE-TANUKI接続性はAdapter + JSON Schemaで吸収するため、UI framework差をつけない。
- 長期安定性は、継続性でComposeが上回るため、Compose側をわずかに上へ振る。
- ただし、Flutterはproduction実績と枯れ具合で上回るため、総合採用第一候補は維持する。
```

### 5.3 結論

```text
GUI Shellの現時点では、Flutterを第一候補にする。
ただし、これはベスト解ではなくベター解である。
```

理由:

```text
- GUI Shellは最初に完成品体験を作る必要がある。
- Flutterは現時点でPC/スマホ同格UIの実績が厚い。
- Compose MPは長期的に魅力的だが、iOS stable化が新しく、初期採用リスクが高い。
- 安全性の中核はUI frameworkではなく、Rust helper / schema / Adapter / Permission / Approval / Auditに置く。
```

---

## 6. Tauriの位置づけ

Tauriはv0.3.1では「Desktop-heavy alternative」として扱う。

### 6.1 強み

```text
- Rust backend
- Capabilities思想
- TypeScript資産と近い
- Desktop Hostに強い
- 軽量
```

### 6.2 弱み

```text
- PC/スマホ同格ではmobile側の検証負荷が高い。
- WebView / JS / native bridge境界の監査が重い。
- UI一貫性ではFlutterに劣る。
```

### 6.3 再浮上条件

```text
- MobileがCompanionに限定される
- Desktop Host重心へ戦略変更する
- TypeScript資産流用を最重視する
- Flutterのdesktop継続性が明確に悪化する
```

---

## 7. フレームワーク依存の局所化

最重要設計原則:

```text
GUI Shellの中核資産を、UI frameworkへ置かない。
```

### 7.1 中核資産

```text
- schema
- Adapter Contract
- Runtime Model
- Capability Model
- Permission Model
- Approval Model
- Audit Event Format
- Recovery Action Format
- Content Exposure Boundary
- Authority Strip Conformance
- Rust helper
- conformance tests
```

### 7.2 UI frameworkが持つ範囲

```text
- 画面描画
- ユーザー入力
- UI状態
- navigation
- theme
- localization
- accessibility
```

### 7.3 正確化

「交換可能」とは、UI移行コストがゼロになるという意味ではない。

```text
守られるもの:
  schema
  Rust helper
  Adapter契約
  Permission / Approval / Audit
  Recovery catalog
  conformance tests

再実装が必要なもの:
  画面
  UI状態
  navigation
  platform-specific UI integration
```

Flutterが廃れてもGUI Shell全体が死ぬわけではない。  
ただし、UI層の再実装コストは発生する。

---

## 8. Flutter採用リスク登録

### 8.1 Google Governance Risk

```text
Risk:
  FlutterはGoogle主導であり、Googleの組織再編・優先度変更・プロジェクト終了文化の影響を受ける。

Impact:
  desktop機能、tooling、Dart/Flutter開発速度、package ecosystemに影響する可能性。

Mitigation:
  UI framework依存を局所化する。
  Core schema、Rust helper、Adapter契約をframework非依存にする。
  Flutter desktop roadmapを定期監視する。
```

### 8.2 Desktop Deprioritization Risk

```text
Risk:
  Flutterのdesktop優先度が下がる可能性。

Impact:
  GUI ShellはPC/スマホ同格であり、desktop品質低下は直撃する。

Mitigation:
  Desktop compatibility matrixを維持する。
  Flutter desktopの重大停滞時はCompose MPまたはTauriへ移行検討する。
```

### 8.3 Dart Ecosystem Risk

```text
Risk:
  Dartを新規導入することで、TypeScript中心の既存資産から離れる。

Impact:
  学習・保守・レビューの認知負荷が増える。

Mitigation:
  DartはUI層に限定する。
  仕様はJSON Schema / OpenAPIで固定する。
  型生成でDart / Rust / TypeScriptを接続する。
```

### 8.4 Migration Cost Risk

```text
Risk:
  Flutterから別UI frameworkへ移行する場合、UI実装の再投資が必要。

Impact:
  画面8枚以上の再実装、状態管理、platform-specific UI調整が発生する。

Mitigation:
  UIとCoreを分離する。
  UI snapshot testsを保持する。
  Core testsとconformance testsをframework非依存にする。
```

---

## 9. Compose MP採用リスク登録

### 9.1 Early Stable Risk

```text
Risk:
  Compose MultiplatformのiOS stable化は新しく、production実績がFlutterより浅い。

Impact:
  GUI Shell規模の長期運用でAPI調整・不具合・知見不足が出る可能性。

Mitigation:
  Compose MPは対抗候補として監視する。
  Flutter撤退条件に該当した場合の移行先として評価継続する。
```

### 9.2 Kotlin Stack Expansion Risk

```text
Risk:
  Kotlin導入により、Flutter案と同様に新規言語・新規toolingが増える。

Impact:
  BLUE-TANUKI / TypeScript資産との距離が生じる。

Mitigation:
  Compose MPを採る場合も、Core schemaとRust helperを不変にする。
```

---

## 10. 撤退・移行条件

Flutter採用は、無条件固定ではない。

### 10.1 Flutter継続条件

```text
- Windows/macOS/Linux desktop対応が実用水準で維持される。
- Android/iOS対応が安定している。
- Flutter toolingが重大劣化しない。
- 主要package ecosystemが維持される。
- Security / platform channel周辺の重大問題が解決可能。
```

### 10.2 再評価条件

```text
- Flutter desktopが1年以上、GUI Shellに必要な改善を止める。
- 公式roadmapでdesktopが明確に後退する。
- Google側の体制縮小により、Dart/Flutterのissue解消速度が著しく落ちる。
- GUI Shellのcritical bugがFlutter起因で回避不能になる。
- Compose MPが1〜2年のproduction実績を積み、Flutterとの差が縮まる。
```

### 10.3 移行先

```text
第一移行先:
  Compose Multiplatform + Rust helper

Desktop特化時の移行先:
  Tauri + TypeScript + Rust
```

---

## 11. 推奨アーキテクチャ v0.3.1

```text
gui-shell/
  docs/
    standards/
      gui-shell-extended-standard.md
    research/
      cross-platform-framework-evaluation.md
      flutter-governance-risk.md
      compose-mp-watchlist.md
    specs/
      adapter-conformance.md
      approval-visibility-boundary.md
      content-exposure-policy.md

  specs/
    runtime.schema.json
    adapter.schema.json
    capability.schema.json
    permission.schema.json
    approval.schema.json
    audit.schema.json
    recovery.schema.json
    diagnostic.schema.json
    update.schema.json
    content_exposure.schema.json

  apps/
    desktop_flutter/
    mobile_flutter/

  packages/
    shell_core/
    shell_ui/
    shell_contracts/
    blue_tanuki_adapter/

  native/
    rust_helper/
      process/
      filesystem/
      network/
      diagnostics/
      update_verification/
      audit_hash/
      secure_ipc/

  installer/
    windows/
    macos/
    linux/

  tooling/
    codegen/
    schema_check/
    conformance_tests/
    ui_snapshot_tests/
```

---

## 12. Core Model

GUI Shellは、初版から以下を持つ。

```text
Runtime
Adapter
Capability
Permission
Approval
AuditEvent
RecoveryAction
DiagnosticReport
Device
Notification
UpdatePolicy
ContentExposurePolicy
CompatibilityProfile
FrameworkRiskProfile
```

v0.3以降で `FrameworkRiskProfile` を追加する。

```json
{
  "framework": "Flutter",
  "version": "string",
  "risk_level": "low | medium | high",
  "governance_risk": "low | medium | high",
  "api_stability": "low | medium | high",
  "production_maturity": "low | medium | high",
  "desktop_priority": "low | medium | high",
  "mobile_priority": "low | medium | high",
  "migration_target": "ComposeMP | Tauri | Other",
  "review_interval_months": 6,
  "exit_conditions": []
}
```

---

## 13. containment整合要件

GUI Shellは、BLUE-TANUKIおよび将来Runtimeの安全境界を破壊してはならない。

### 13.1 Authority Strip Conformance

```text
MUST:
- inbound authority keysをstripする。
- external metadataによるauthority昇格を禁止する。
- Runtimeが許可していないauthority_contextを生成しない。
- GUI入力を権威根拠として扱わない。
```

### 13.2 Content Exposure Boundary

```text
content_visibility:
  none
  hash_only
  summary
  redacted
  full
```

原則:

```text
- content_visibility=none の場合、raw contentを表示してはならない。
- hash_only の場合、payload_hashのみ表示する。
- summary の場合、RuntimeまたはAdapterが許可したsummaryのみ表示する。
- redacted の場合、redaction済み差分のみ表示する。
- full の場合のみfull content表示を許可する。
```

### 13.3 Approval Edit制限

```text
- EditはRuntimeが許可したfieldに限定する。
- authority fieldは編集不可。
- hidden / sealed / sacred domain fieldは編集不可。
- edit後payloadは再hash化し、再Approvalまたは再Validationを通す。
- edit内容はAudit対象とする。
```

---

## 14. Phase計画 v0.3.1

### Phase 0: Standard / Selection Freeze

```text
- GUI Shell Extended Standard v0.3.1確定
- Flutter + Rust helperを第一候補として採用
- Flutter governance riskを明記
- Compose MPを対抗候補としてwatchlist化
- UI framework依存をUI層へ局所化する原則を明記
- FrameworkRiskProfile定義
- Adapter Conformance定義
- Content Exposure Boundary定義
- Authority Strip Conformance定義
```

### Phase 1: Schema / Contract

```text
- runtime.schema.json
- adapter.schema.json
- capability.schema.json
- permission.schema.json
- approval.schema.json
- audit.schema.json
- recovery.schema.json
- diagnostic.schema.json
- update.schema.json
- content_exposure.schema.json
- framework_risk_profile.schema.json
- codegen
```

### Phase 2: Shell Skeleton

```text
- Flutter app skeleton
- Shell Core
- Runtime Registry
- Adapter Loader
- Permission Ledger
- Approval Queue
- Audit Store
```

### Phase 3: Rust Helper

```text
- process control
- port check
- filesystem diagnostics
- network diagnostics
- hash/signature utilities
- recovery execution
- secure IPC
```

### Phase 4: BLUE-TANUKI Adapter

```text
- health
- ready
- runtime snapshot
- authority trace
- notifications
- approvals
- audit events
- diagnostics export
- recovery
```

### Phase 5: Desktop Product Shell

```text
- Dashboard
- Setup Doctor
- Runtime Center
- Permission Center
- Approval Center
- Audit Viewer
- Recovery Center
- Settings
- Installer
```

### Phase 6: Mobile Shell / Companion

```text
- Device pairing
- Notifications
- Approval
- Runtime status
- Emergency stop
- Recovery instruction
```

---

## 15. Codex投入可能な初期指示 v0.3.1

```text
Task:
  Initialize GUI Shell repository as a generic runtime operation shell.

Architecture:
  - UI framework: Flutter
  - Native helper: Rust
  - Contracts: JSON Schema / OpenAPI
  - Reference runtime: BLUE-TANUKI via Adapter
  - BLUE-TANUKI implementation is frozen.

Constraints:
  - Do not implement BLUE-TANUKI-specific logic in Shell Core.
  - Do not place core assets inside Flutter-specific code.
  - Define schemas before UI implementation.
  - Add Adapter Conformance with authority strip requirements.
  - Add Content Exposure Boundary for approvals.
  - Add Permission / Approval / Audit / Recovery models.
  - Add FrameworkRiskProfile for Flutter governance and Compose MP watchlist.
  - Treat Flutter as a replaceable UI layer, not the system core.
  - Treat BLUE-TANUKI as the first reference adapter only.
  - Do not start product UI until schemas and conformance tests exist.

Deliverables:
  - docs/standards/gui-shell-extended-standard.md
  - docs/research/flutter-governance-risk.md
  - docs/research/compose-mp-watchlist.md
  - docs/specs/adapter-conformance.md
  - docs/specs/content-exposure-policy.md
  - specs/*.schema.json
  - minimal codegen setup
  - conformance test skeleton
```

---

## 16. 最終判断

```text
Flutter + Rust helperを第一候補とする。

ただし、Flutterはベストではなくベターである。
理由は、production実績・PC/スマホ同格UI・開発速度・UI一貫性の総合点が現時点で最も高いため。

一方で、Google governance risk、desktop優先度低下リスク、Dart導入リスクは明記する。
Compose Multiplatformは、JetBrains/Kotlin地盤により継続性で強いため、対抗候補として監視する。

GUI Shellの中核資産はFlutterに置かない。
schema、Rust helper、Adapter Contract、Permission / Approval / Audit、Recoveryを中核資産とする。

Flutterが廃れてもGUI Shell全体が死なない設計にする。
ただし、UI移行コストがゼロになるわけではない。
UI層の再実装は必要になる。
```

確信度: **70%**

この70%は「Flutter + Rust helper を今選ぶこと」の妥当性である。  
「GUI Shellを汎用Shellとして設計すること」自体の確信度は **95%** とする。

---

## 17. Lock Decision

本ドキュメントを、GUI Shell Phase 0 のロック版とする。

```text
Phase 0 Lock:
  - Generic GUI Shell方針
  - BLUE-TANUKI凍結
  - Flutter + Rust helper第一候補
  - Compose MP watchlist
  - Tauri desktop-heavy fallback
  - FrameworkRiskProfile
  - Adapter Conformance
  - Content Exposure Boundary
  - Authority Strip Conformance
  - Schema-first / conformance-first
```

以後の作業は、実装ではなく、まず以下へ進める。

```text
1. リポジトリ初期化
2. docs/standards 作成
3. docs/specs 作成
4. specs/*.schema.json 作成
5. codegen skeleton
6. conformance test skeleton
```

---

## 18. 結語

技術選定は、絶対的な正解探しではない。  
GUI Shellでは、現時点の相対最適を選び、撤退条件と移行先を同時に固定することが重要である。

```text
ベストではなくベターを選ぶ。
ただし、リスクは文書化する。
UI frameworkは交換可能な層に閉じる。
Core資産はframework非依存にする。
```

これがv0.3.1 Phase 0 Lockの結論である。
