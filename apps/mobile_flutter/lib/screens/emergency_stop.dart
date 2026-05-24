import 'package:flutter/material.dart';

import 'shared.dart';

class EmergencyStop extends StatelessWidget {
  const EmergencyStop({super.key});

  @override
  Widget build(BuildContext context) {
    return const MobilePage(
      title: 'Emergency Stop',
      children: [
        StatusTile(icon: Icons.stop_circle_outlined, title: 'Request Only', subtitle: 'mobile requests stop through Shell Core; it is not independent authority'),
        StatusTile(icon: Icons.receipt_long_outlined, title: 'Audit Required', subtitle: 'stop request must create AuditEvent and RecoveryAction mapping'),
      ],
    );
  }
}
