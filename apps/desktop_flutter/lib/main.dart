import 'package:flutter/material.dart';

import 'screens/approval_center.dart';
import 'screens/audit_viewer.dart';
import 'screens/dashboard.dart';
import 'screens/agent_center.dart';
import 'screens/permission_center.dart';
import 'screens/recovery_center.dart';
import 'screens/runtime_center.dart';
import 'screens/settings.dart';
import 'screens/setup_doctor.dart';
import 'services/shell_core_client.dart';

void main() {
  runApp(const GuiShellDesktopApp());
}

class GuiShellDesktopApp extends StatelessWidget {
  const GuiShellDesktopApp({super.key});

  @override
  Widget build(BuildContext context) {
    final client = ShellCoreClient.local();
    return MaterialApp(
      title: 'GUI Shell',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: const Color(0xff2f6f5e),
        useMaterial3: true,
        visualDensity: VisualDensity.compact,
      ),
      home: ShellHomePage(client: client),
    );
  }
}

class ShellHomePage extends StatefulWidget {
  const ShellHomePage({super.key, required this.client});

  final ShellCoreClient client;

  @override
  State<ShellHomePage> createState() => _ShellHomePageState();
}

class _ShellHomePageState extends State<ShellHomePage> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      Dashboard(client: widget.client),
      SetupDoctor(client: widget.client),
      RuntimeCenter(client: widget.client),
      AgentCenter(client: widget.client),
      PermissionCenter(client: widget.client),
      ApprovalCenter(client: widget.client),
      AuditViewer(client: widget.client),
      RecoveryCenter(client: widget.client),
      SettingsScreen(client: widget.client),
    ];

    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: selectedIndex,
            onDestinationSelected: (index) =>
                setState(() => selectedIndex = index),
            labelType: NavigationRailLabelType.all,
            destinations: const [
              NavigationRailDestination(
                  icon: Icon(Icons.dashboard_outlined),
                  selectedIcon: Icon(Icons.dashboard),
                  label: Text('Dashboard')),
              NavigationRailDestination(
                  icon: Icon(Icons.build_circle_outlined),
                  selectedIcon: Icon(Icons.build_circle),
                  label: Text('Doctor')),
              NavigationRailDestination(
                  icon: Icon(Icons.hub_outlined),
                  selectedIcon: Icon(Icons.hub),
                  label: Text('Runtime')),
              NavigationRailDestination(
                  icon: Icon(Icons.smart_toy_outlined),
                  selectedIcon: Icon(Icons.smart_toy),
                  label: Text('Agent')),
              NavigationRailDestination(
                  icon: Icon(Icons.key_outlined),
                  selectedIcon: Icon(Icons.key),
                  label: Text('Permission')),
              NavigationRailDestination(
                  icon: Icon(Icons.fact_check_outlined),
                  selectedIcon: Icon(Icons.fact_check),
                  label: Text('Approval')),
              NavigationRailDestination(
                  icon: Icon(Icons.receipt_long_outlined),
                  selectedIcon: Icon(Icons.receipt_long),
                  label: Text('Audit')),
              NavigationRailDestination(
                  icon: Icon(Icons.health_and_safety_outlined),
                  selectedIcon: Icon(Icons.health_and_safety),
                  label: Text('Recovery')),
              NavigationRailDestination(
                  icon: Icon(Icons.settings_outlined),
                  selectedIcon: Icon(Icons.settings),
                  label: Text('Settings')),
            ],
          ),
          const VerticalDivider(width: 1),
          Expanded(child: pages[selectedIndex]),
        ],
      ),
    );
  }
}
