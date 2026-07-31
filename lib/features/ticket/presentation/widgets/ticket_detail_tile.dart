import 'package:flutter/material.dart';

import '../../../../core/constants/app_spacing.dart';

/// Read-only label/value row for ticket details.
class TicketDetailTile extends StatelessWidget {
  const TicketDetailTile({
    super.key,
    required this.label,
    required this.value,
    this.trailing,
  });

  final String label;
  final String value;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: theme.textTheme.labelLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  value,
                  style: theme.textTheme.bodyLarge,
                ),
              ),
              ?trailing,
            ],
          ),
        ],
      ),
    );
  }
}
