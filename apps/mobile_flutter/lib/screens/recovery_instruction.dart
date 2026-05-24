import 'package:flutter/material.dart';

import 'shared.dart';

class RecoveryInstruction extends StatelessWidget {
  const RecoveryInstruction({super.key});

  @override
  Widget build(BuildContext context) {
    return const MobilePage(
      title: 'Recovery Instruction',
      children: [
        StatusTile(icon: Icons.health_and_safety_outlined, title: 'Permission Recovery', subtitle: 'review pending approval and retry after Shell Core approval'),
        StatusTile(icon: Icons.link_off_outlined, title: 'Revocation Path', subtitle: 'pairing includes device_id, pairing_id, audit event, revocation, and recovery path'),
      ],
    );
  }
}
