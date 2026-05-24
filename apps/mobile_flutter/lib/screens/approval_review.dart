import 'package:flutter/material.dart';

import 'shared.dart';

class ApprovalReview extends StatelessWidget {
  const ApprovalReview({super.key});

  @override
  Widget build(BuildContext context) {
    return const MobilePage(
      title: 'Approval Review',
      children: [
        StatusTile(icon: Icons.visibility_off_outlined, title: 'Projection', subtitle: 'content_visibility=redacted; hidden payload unavailable'),
        StatusTile(icon: Icons.lock_outline, title: 'Protected Fields', subtitle: 'runtime_id, permission_id, payload_hash locked'),
        StatusTile(icon: Icons.history_outlined, title: 'Audit', subtitle: 'approval action requires Shell Core audit event'),
      ],
    );
  }
}
