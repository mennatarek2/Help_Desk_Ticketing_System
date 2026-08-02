import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../domain/entities/ticket_history_entry.dart';
import '../providers/ticket_history_provider.dart';

/// Displays a chronological list of ticket history events.
class TicketHistoryTimeline extends ConsumerWidget {
  const TicketHistoryTimeline({super.key, required this.ticketId});

  final String ticketId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsync = ref.watch(ticketHistoryProvider(ticketId));
    final theme = Theme.of(context);

    return historyAsync.when(
      data: (entries) {
        if (entries.isEmpty) {
          return Text(
            'No history yet.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var index = 0; index < entries.length; index++) ...[
              _HistoryEntryItem(entry: entries[index]),
              if (index != entries.length - 1)
                const SizedBox(height: AppSpacing.sm),
            ],
          ],
        );
      },
      loading: () => const LoadingWidget(message: 'Loading history...'),
      error: (error, _) => Text(
        'Unable to load history.',
        style: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.error,
        ),
      ),
    );
  }
}

class _HistoryEntryItem extends StatelessWidget {
  const _HistoryEntryItem({required this.entry});

  final TicketHistoryEntry entry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          Icons.history_rounded,
          size: 18,
          color: theme.colorScheme.primary,
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                entry.message,
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                DateFormatter.display(entry.timestamp),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
