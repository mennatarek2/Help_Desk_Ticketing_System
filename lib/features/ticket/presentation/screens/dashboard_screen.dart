import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/dashboard_statistics_provider.dart';
import '../providers/ticket_list_provider.dart';
import '../state/dashboard_statistics.dart';
import '../widgets/stat_summary_card.dart';

/// Displays ticket summary statistics.
class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statisticsAsync = ref.watch(dashboardStatisticsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            tooltip: 'Refresh',
            onPressed: () =>
                ref.read(ticketListProvider.notifier).refresh(),
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: statisticsAsync.when(
        data: (statistics) => _DashboardContent(statistics: statistics),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => _DashboardError(
          message: error.toString(),
          onRetry: () => ref.read(ticketListProvider.notifier).refresh(),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(RouteNames.ticketList),
        icon: const Icon(Icons.confirmation_number_outlined),
        label: const Text('View Tickets'),
      ),
    );
  }
}

class _DashboardContent extends StatelessWidget {
  const _DashboardContent({required this.statistics});

  final DashboardStatistics statistics;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = _crossAxisCountForWidth(constraints.maxWidth);
        const spacing = 16.0;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Overview',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'Track your support tickets at a glance.',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
              const SizedBox(height: 24),
              Wrap(
                spacing: spacing,
                runSpacing: spacing,
                children: [
                  SizedBox(
                    width: _cardWidth(
                      maxWidth: constraints.maxWidth,
                      crossAxisCount: crossAxisCount,
                      spacing: spacing,
                    ),
                    child: StatSummaryCard(
                      title: 'Total Tickets',
                      value: statistics.total,
                      icon: Icons.confirmation_number_outlined,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  SizedBox(
                    width: _cardWidth(
                      maxWidth: constraints.maxWidth,
                      crossAxisCount: crossAxisCount,
                      spacing: spacing,
                    ),
                    child: StatSummaryCard(
                      title: 'Open',
                      value: statistics.open,
                      icon: Icons.mark_email_unread_outlined,
                      color: AppColors.open,
                    ),
                  ),
                  SizedBox(
                    width: _cardWidth(
                      maxWidth: constraints.maxWidth,
                      crossAxisCount: crossAxisCount,
                      spacing: spacing,
                    ),
                    child: StatSummaryCard(
                      title: 'In Progress',
                      value: statistics.inProgress,
                      icon: Icons.pending_actions_outlined,
                      color: AppColors.inProgress,
                    ),
                  ),
                  SizedBox(
                    width: _cardWidth(
                      maxWidth: constraints.maxWidth,
                      crossAxisCount: crossAxisCount,
                      spacing: spacing,
                    ),
                    child: StatSummaryCard(
                      title: 'Closed',
                      value: statistics.closed,
                      icon: Icons.task_alt_outlined,
                      color: AppColors.closed,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  int _crossAxisCountForWidth(double width) {
    if (width >= 900) {
      return 4;
    }
    if (width >= 600) {
      return 2;
    }
    return 1;
  }

  double _cardWidth({
    required double maxWidth,
    required int crossAxisCount,
    required double spacing,
  }) {
    if (crossAxisCount == 1) {
      return maxWidth;
    }

    return (maxWidth - spacing * (crossAxisCount - 1)) / crossAxisCount;
  }
}

class _DashboardError extends StatelessWidget {
  const _DashboardError({
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 48,
              color: theme.colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              'Unable to load dashboard',
              style: theme.textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }
}
