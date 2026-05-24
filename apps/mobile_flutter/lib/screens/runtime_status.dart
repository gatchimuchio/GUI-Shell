import 'package:flutter/material.dart';

import 'shared.dart';

class RuntimeStatus extends StatelessWidget {
  const RuntimeStatus({super.key});

  @override
  Widget build(BuildContext context) {
    return const MobilePage(
      title: 'Runtime Status',
      children: [
        StatusTile(icon: Icons.check_circle_outline, title: 'blue_tanuki', subtitle: 'ready'),
        StatusTile(icon: Icons.security_outlined, title: 'Authority', subtitle: 'Shell Core remains the authority source'),
      ],
    );
  }
}
