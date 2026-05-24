import 'package:flutter/material.dart';

import 'shared.dart';

class MobileNotifications extends StatelessWidget {
  const MobileNotifications({super.key});

  @override
  Widget build(BuildContext context) {
    return const MobilePage(
      title: 'Notifications',
      children: [
        StatusTile(icon: Icons.notifications_active_outlined, title: 'Runtime Ready', subtitle: 'Adapter reports reference runtime ready'),
        StatusTile(icon: Icons.warning_amber_outlined, title: 'Recovery Warning', subtitle: 'Permission approval required before action can run'),
      ],
    );
  }
}
