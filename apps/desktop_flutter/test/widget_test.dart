import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gui_shell_desktop/main.dart';
import 'package:gui_shell_desktop/screens/approval_center.dart';
import 'package:gui_shell_desktop/screens/setup_doctor.dart';
import 'package:gui_shell_desktop/services/shell_core_client.dart';

void main() {
  testWidgets('GUI Shell desktop app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const GuiShellDesktopApp());

    expect(find.byType(MaterialApp), findsOneWidget);
    expect(find.byType(NavigationRail), findsOneWidget);
    expect(find.text('Dashboard'), findsWidgets);
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
