import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../state/dashboard_statistics.dart';
import 'ticket_list_provider.dart';

/// Derives dashboard statistics from the ticket list.
final dashboardStatisticsProvider = Provider<AsyncValue<DashboardStatistics>>(
  (ref) {
    final ticketsAsync = ref.watch(ticketListProvider);

    return ticketsAsync.when(
      data: (tickets) => AsyncData(DashboardStatistics.fromTickets(tickets)),
      loading: () => const AsyncLoading<DashboardStatistics>(),
      error: (error, stackTrace) =>
          AsyncError<DashboardStatistics>(error, stackTrace),
    );
  },
);
