import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/providers/theme_mode_provider.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/async_error_view.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../../core/widgets/offline_banner.dart';
import '../providers/dashboard_statistics_provider.dart';
import '../providers/export_tickets_controller.dart';
import '../providers/ticket_list_provider.dart';
import '../state/dashboard_statistics.dart';
import '../widgets/dashboard_card.dart';

/// Displays ticket summary statistics.
class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  bool _isExporting = false;

  Future<void> _exportTickets() async {
    setState(() => _isExporting = true);

    final result = await ref.read(exportTicketsControllerProvider).export();

    if (!mounted) {
      return;
    }

    setState(() => _isExporting = false);

    switch (result) {
      case ExportTicketsSuccess(:final filePath):
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Exported to $filePath')),
        );
      case ExportTicketsFailure(:final message):
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final statisticsAsync = ref.watch(dashboardStatisticsProvider);
    final themeMode = ref.watch(themeModeProvider).value ?? ThemeMode.system;
    final isDark = themeMode == ThemeMode.dark ||
        (themeMode == ThemeMode.system &&
            MediaQuery.platformBrightnessOf(context) == Brightness.dark);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            tooltip: isDark ? 'Switch to light mode' : 'Switch to dark mode',
            onPressed: () => ref.read(themeModeProvider.notifier).toggle(),
            icon: Icon(
              isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
            ),
          ),
          IconButton(
            tooltip: 'Export tickets',
            onPressed: _isExporting ? null : _exportTickets,
            icon: _isExporting
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.download_rounded),
          ),
          IconButton(
            tooltip: 'Refresh',
            onPressed: () =>
                ref.read(ticketListProvider.notifier).refresh(),
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: Column(
        children: [
          const OfflineBanner(),
          Expanded(
            child: statisticsAsync.when(
              data: (statistics) => _DashboardContent(statistics: statistics),
              loading: () => const LoadingWidget(),
              error: (error, _) => AsyncErrorView(
                title: 'Unable to load dashboard',
                error: error,
                onRetry: () =>
                    ref.read(ticketListProvider.notifier).refresh(),
              ),
            ),
          ),
        ],
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
        const spacing = AppSpacing.md;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Overview',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Track your support tickets at a glance.',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
              const SizedBox(height: AppSpacing.lg),
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
                    child: DashboardCard(
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
                    child: DashboardCard(
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
                    child: DashboardCard(
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
                    child: DashboardCard(
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
