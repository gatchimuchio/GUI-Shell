import 'package:flutter/material.dart';

import '../services/shell_core_client.dart';
import 'shared.dart';

class ProblemsPanel extends StatelessWidget {
  const ProblemsPanel({super.key, required this.client});

  final ShellCoreClient client;

  @override
  Widget build(BuildContext context) {
    final problems = client.getSnapshot().problems;
    return ShellPage(
      title: 'Problems Panel',
      children: [
        const SectionList(title: 'Phase B Boundary', rows: [
          'Release blockers are visible here without making Phase B owner-use fail.',
          'Rows are display-only; authority and recovery execution remain Shell Core responsibilities.',
        ]),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columns: const [
              DataColumn(label: Text('Item')),
              DataColumn(label: Text('Classification')),
              DataColumn(label: Text('Reason')),
              DataColumn(label: Text('Required Action')),
              DataColumn(label: Text('Blocks Release')),
            ],
            rows: [
              for (final problem in problems)
                DataRow(cells: [
                  DataCell(Text(
                      problem.item.isEmpty ? problem.message : problem.item)),
                  DataCell(Text(problem.classification)),
                  DataCell(Text(problem.reason)),
                  DataCell(Text(problem.requiredAction)),
                  DataCell(Text(problem.blocksRelease ? 'yes' : 'no')),
                ]),
            ],
          ),
        ),
      ],
    );
  }
}
