import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gui_shell_desktop/main.dart';
import 'package:gui_shell_desktop/screens/approval_center.dart';
import 'package:gui_shell_desktop/screens/authority_map.dart';
import 'package:gui_shell_desktop/screens/dashboard.dart';
import 'package:gui_shell_desktop/screens/evidence_center.dart';
import 'package:gui_shell_desktop/screens/problems_panel.dart';
import 'package:gui_shell_desktop/screens/recovery_center.dart';
import 'package:gui_shell_desktop/screens/setup_doctor.dart';
import 'package:gui_shell_desktop/screens/shared.dart';
import 'package:gui_shell_desktop/screens/trust_center.dart';
import 'package:gui_shell_desktop/services/shell_core_client.dart';

void main() {
  testWidgets('GUI Shell desktop app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const GuiShellDesktopApp());

    expect(find.byType(MaterialApp), findsOneWidget);
    expect(find.byType(NavigationRail), findsOneWidget);
    expect(find.text('Dashboard'), findsWidgets);
    expect(find.text('Trust'), findsOneWidget);
    expect(find.text('Authority'), findsOneWidget);
  });

  testWidgets('Dashboard shows Phase A complete and Phase B complete',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: Dashboard(client: ShellCoreClient.mock())),
      ),
    );

    expect(find.textContaining('Phase A: complete'), findsOneWidget);
    expect(find.textContaining('Phase B: complete'), findsOneWidget);
    expect(find.textContaining('Completed product release: not claimed'),
        findsOneWidget);
  });

  testWidgets('Status bar shows Phase B owner-use and release not claimed',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ShellStatusBar(snapshot: ShellCoreClient.mock().getSnapshot()),
        ),
      ),
    );

    expect(find.textContaining('Phase: B owner-use'), findsOneWidget);
    expect(find.textContaining('Release: not claimed'), findsOneWidget);
  });

  testWidgets('Problems panel shows release blockers without Phase B failure',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: ProblemsPanel(client: ShellCoreClient.mock())),
      ),
    );

    expect(find.text('Problems Panel'), findsOneWidget);
    expect(find.textContaining('measured Windows installed-path first-run'),
        findsOneWidget);
    expect(find.textContaining('release_blocker'), findsWidgets);
    expect(find.text('Recovery'), findsOneWidget);
    expect(find.text('Blocks Owner Use'), findsOneWidget);
    expect(find.text('Blocks Product Release'), findsOneWidget);
    expect(find.textContaining('recover-windows-evidence'), findsOneWidget);
    expect(find.textContaining('release_evidence/windows_installed_smoke.json'),
        findsWidgets);
    expect(find.textContaining('without making Phase B owner-use fail'),
        findsOneWidget);
  });

  testWidgets('Evidence center shows strict Windows expected failure',
      (WidgetTester tester) async {
    final releaseEvidence =
        File('release_evidence/windows_installed_smoke.json');
    final existedBefore = releaseEvidence.existsSync();
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: EvidenceCenter(client: ShellCoreClient.mock())),
      ),
    );

    expect(find.text('Evidence Center'), findsOneWidget);
    expect(find.textContaining('strict_windows_release: expected fail'),
        findsOneWidget);
    expect(
        find.textContaining(
            'missing measured Windows evidence: release_blocker'),
        findsOneWidget);
    expect(releaseEvidence.existsSync(), existedBefore);
  });

  testWidgets('Recovery playbook marks Windows evidence safe for Phase B',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: RecoveryCenter(client: ShellCoreClient.mock())),
      ),
    );

    expect(find.text('Recovery Playbook'), findsOneWidget);
    expect(
        find.textContaining('measured Windows installed-path evidence missing'),
        findsOneWidget);
    expect(find.textContaining('true'), findsWidgets);
    expect(find.text('Command'), findsOneWidget);
    expect(find.text('Path'), findsOneWidget);
  });

  testWidgets('Trust and Authority surfaces are restored',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: TrustCenter(client: ShellCoreClient.mock())),
      ),
    );

    expect(find.text('Trust Center'), findsOneWidget);
    expect(find.textContaining('workspace_trust'), findsOneWidget);
    expect(find.textContaining('Shell Core capability'), findsOneWidget);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: AuthorityMap(client: ShellCoreClient.mock())),
      ),
    );

    expect(find.text('Authority Map'), findsOneWidget);
    expect(find.textContaining('filesystem.write'), findsWidgets);
    expect(find.textContaining('Authority decisions remain in Shell Core'),
        findsOneWidget);
  });

  test('Setup Doctor client surface is structured and non-authoritative', () {
    final snapshot = ShellCoreClient.local().getSnapshot();

    expect(ShellCoreClient.local().mode, 'local');
    expect(ShellCoreClient.mock().mode, 'mock');
    expect(snapshot.setupDoctorChecks, isNotEmpty);
    expect(snapshot.installerGrantsAuthority, isFalse);
    expect(snapshot.installerSilentlyApprovesPermissions, isFalse);
    expect(
      snapshot.setupDoctorChecks.where((check) => check.grantsAuthority),
      isEmpty,
    );
  });

  test('local client reads structured snapshot data', () {
    final tempDir = Directory.systemTemp.createTempSync('gui-shell-test-');
    addTearDown(() => tempDir.deleteSync(recursive: true));
    final snapshotFile = File('${tempDir.path}/shell_snapshot.json');
    snapshotFile.writeAsStringSync(jsonEncode({
      'runtimes': [
        {
          'runtime_id': 'runtime-from-json',
          'name': 'Runtime From Json',
          'status': 'ready',
          'adapter_id': 'adapter-from-json',
          'diagnostic_summary': 'loaded from local snapshot'
        }
      ],
      'agent_sessions': [],
      'permissions': [],
      'pending_approvals': [],
      'audit_events': [],
      'recovery_actions': [],
      'invariant_flags': {
        'flutter_imported_by_shell_core': true,
        'blue_tanuki_imported_by_shell_core': false
      },
      'setup_doctor_status': 'pass',
      'installer_grants_authority': false,
      'installer_silently_approves_permissions': false,
      'setup_doctor_checks': [
        {
          'check_id': 'local.json',
          'status': 'pass',
          'message': 'Loaded local diagnostic JSON',
          'recovery_instruction': null,
          'grants_authority': false
        }
      ]
    }));

    final client = ShellCoreClient.local(snapshotPath: snapshotFile.path);
    final snapshot = client.getSnapshot();

    expect(client.mode, 'local');
    expect(snapshot.runtimes.single.runtimeId, 'runtime-from-json');
    expect(snapshot.setupDoctorChecks.single.checkId, 'local.json');
    expect(snapshot.invariantFlags['flutter_imported_by_shell_core'], isTrue);
    expect(snapshot.snapshotSource, 'local');
    expect(snapshot.operationStatus.releaseState, 'not claimed');
  });

  test('local snapshot fallback does not claim release-ready', () {
    final tempDir = Directory.systemTemp.createTempSync('gui-shell-missing-');
    addTearDown(() => tempDir.deleteSync(recursive: true));
    final missingPath = '${tempDir.path}/missing_snapshot.json';

    final snapshot =
        ShellCoreClient.local(snapshotPath: missingPath).getSnapshot();

    expect(snapshot.snapshotSource, 'fallback');
    expect(snapshot.snapshotFreshness, 'missing');
    expect(snapshot.operationStatus.releaseState, 'not claimed');
    expect(
        snapshot.problems
            .any((problem) => problem.item == 'local snapshot missing'),
        isTrue);
  });

  test('local snapshot parse failure falls back safely', () {
    final tempDir = Directory.systemTemp.createTempSync('gui-shell-bad-json-');
    addTearDown(() => tempDir.deleteSync(recursive: true));
    final snapshotFile = File('${tempDir.path}/bad_snapshot.json')
      ..writeAsStringSync('{bad json');

    final snapshot =
        ShellCoreClient.local(snapshotPath: snapshotFile.path).getSnapshot();

    expect(snapshot.snapshotSource, 'fallback');
    expect(snapshot.snapshotFreshness, 'parse failed');
    expect(snapshot.operationStatus.releaseState, 'not claimed');
    expect(
        snapshot.problems
            .any((problem) => problem.item == 'local snapshot parse failed'),
        isTrue);
  });

  testWidgets('Setup Doctor UI displays local diagnostic data',
      (WidgetTester tester) async {
    final tempDir = Directory.systemTemp.createTempSync('gui-shell-ui-test-');
    addTearDown(() => tempDir.deleteSync(recursive: true));
    final snapshotFile = File('${tempDir.path}/shell_snapshot.json');
    snapshotFile.writeAsStringSync(jsonEncode({
      'runtimes': [
        {
          'runtime_id': 'runtime-ui-json',
          'name': 'Runtime UI Json',
          'status': 'ready',
          'adapter_id': 'adapter-ui-json',
          'diagnostic_summary': 'loaded from local snapshot'
        }
      ],
      'agent_sessions': [],
      'permissions': [],
      'pending_approvals': [],
      'audit_events': [],
      'recovery_actions': [],
      'invariant_flags': {},
      'setup_doctor_status': 'pass',
      'installer_grants_authority': false,
      'installer_silently_approves_permissions': false,
      'setup_doctor_checks': [
        {
          'check_id': 'local.ui',
          'status': 'pass',
          'message': 'UI loaded local diagnostic JSON',
          'recovery_instruction': null,
          'grants_authority': false
        }
      ]
    }));

    await tester.pumpWidget(
      MaterialApp(
        home: SetupDoctor(
          client: ShellCoreClient.local(snapshotPath: snapshotFile.path),
        ),
      ),
    );

    expect(find.textContaining('local.ui: pass'), findsOneWidget);
    expect(find.textContaining('runtime-ui-json: ready'), findsOneWidget);
  });

  testWidgets('Approval Center does not expose hidden full payload',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: ApprovalCenter(client: ShellCoreClient.local())),
      ),
    );

    expect(find.textContaining('Visibility: redacted'), findsOneWidget);
    expect(find.textContaining('[redacted]'), findsOneWidget);
    expect(find.textContaining('hello'), findsNothing);
  });
}
