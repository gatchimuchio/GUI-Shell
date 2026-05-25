import 'package:flutter/material.dart';

import '../models/generated_contracts.dart';

class ShellPage extends StatelessWidget {
  const ShellPage({super.key, required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 16),
            ...children.map((child) => Padding(
                padding: const EdgeInsets.only(bottom: 16), child: child)),
          ],
        ),
      ),
    );
  }
}

class MetricItem {
  const MetricItem({required this.label, required this.value});

  final String label;
  final String value;
}

class MetricRow extends StatelessWidget {
  const MetricRow({super.key, required this.items});

  final List<MetricItem> items;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        for (final item in items)
          SizedBox(
            width: 150,
            child: BorderedPanel(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.value,
                      style: Theme.of(context).textTheme.headlineMedium),
                  Text(item.label),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class BorderedPanel extends StatelessWidget {
  const BorderedPanel({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(padding: const EdgeInsets.all(12), child: child),
    );
  }
}

class StatusPill extends StatelessWidget {
  const StatusPill({super.key, required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text('$label: $value'),
      visualDensity: VisualDensity.compact,
    );
  }
}

class ShellStatusBar extends StatelessWidget {
  const ShellStatusBar({super.key, required this.snapshot});

  final ShellSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final operation = snapshot.operationStatus;
    return Material(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: SizedBox(
        height: 44,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          child: Row(
            children: [
              const StatusPill(label: 'Phase', value: 'B owner-use'),
              const SizedBox(width: 8),
              StatusPill(label: 'Runtime', value: operation.runtimeStatus),
              const SizedBox(width: 8),
              StatusPill(
                  label: 'Trust/Invariants',
                  value:
                      '${operation.trustStatus}/${operation.invariantStatus}'),
              const SizedBox(width: 8),
              StatusPill(
                  label: 'Approvals',
                  value: '${operation.pendingApprovalsCount} pending'),
              const SizedBox(width: 8),
              StatusPill(label: 'Audit', value: operation.auditChainStatus),
              const SizedBox(width: 8),
              StatusPill(
                  label: 'Problems', value: '${operation.problemsCount}'),
              const SizedBox(width: 8),
              StatusPill(label: 'Release', value: operation.releaseState),
              const SizedBox(width: 8),
              StatusPill(label: 'Snapshot', value: snapshot.snapshotSource),
            ],
          ),
        ),
      ),
    );
  }
}

class SectionList extends StatelessWidget {
  const SectionList({super.key, required this.title, required this.rows});

  final String title;
  final List<String> rows;

  @override
  Widget build(BuildContext context) {
    return BorderedPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          for (final row in rows)
            Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Text(row)),
        ],
      ),
    );
  }
}
