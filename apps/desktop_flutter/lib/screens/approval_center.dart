import 'package:flutter/material.dart';

import '../services/shell_core_client.dart';
import 'shared.dart';

class ApprovalCenter extends StatelessWidget {
  const ApprovalCenter({super.key, required this.client});

  final ShellCoreClient client;

  @override
  Widget build(BuildContext context) {
    final approvals = client.getSnapshot().pendingApprovals;
    return ShellPage(
      title: 'Approval Center',
      children: [
        for (final approval in approvals)
          BorderedPanel(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${approval.operation}  ${approval.status}', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                Text('Visibility: ${approval.contentVisibility}'),
                const SizedBox(height: 8),
                Wrap(spacing: 8, runSpacing: 8, children: [
                  for (final entry in approval.projectedContent.entries) Chip(label: Text('${entry.key}: ${entry.value}')),
                ]),
                const SizedBox(height: 8),
                SectionList(title: 'Editable Fields', rows: approval.editableFields),
                SectionList(title: 'Locked Fields', rows: approval.protectedFields),
              ],
            ),
          ),
      ],
    );
  }
}
