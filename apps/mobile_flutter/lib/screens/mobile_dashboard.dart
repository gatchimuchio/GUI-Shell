import 'package:flutter/material.dart';

import 'shared.dart';

class MobileDashboard extends StatelessWidget {
  const MobileDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return const MobilePage(
      title: 'Mobile Dashboard',
      children: [
        StatusTile(icon: Icons.hub_outlined, title: 'Runtime', subtitle: 'BLUE-TANUKI ready through adapter contract'),
        StatusTile(icon: Icons.fact_check_outlined, title: 'Approvals', subtitle: '1 pending review with redacted projection'),
        StatusTile(icon: Icons.link_outlined, title: 'Pairing', subtitle: 'device_id + pairing_id + operator confirmation required'),
      ],
    );
  }
}
