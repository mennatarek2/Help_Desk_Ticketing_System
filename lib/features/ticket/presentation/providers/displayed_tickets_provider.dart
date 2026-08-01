import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/ticket.dart';
import '../../domain/entities/ticket_sort_order.dart';
import '../../domain/entities/ticket_status.dart';
import 'ticket_filter_provider.dart';
import 'ticket_list_provider.dart';
import 'ticket_search_provider.dart';
import 'ticket_sort_provider.dart';

/// Applies search, filter, and sort on the in-memory ticket list.
///
/// Uses synchronous derivation to avoid loading flicker when filters change.
final displayedTicketsProvider = Provider<AsyncValue<List<Ticket>>>((ref) {
  final ticketsAsync = ref.watch(ticketListProvider);
  final searchQuery = ref.watch(ticketSearchProvider);
  final statusFilter = ref.watch(ticketFilterProvider);
  final sortOrder = ref.watch(ticketSortProvider);

  return ticketsAsync.when(
    data: (tickets) {
      var result = _applyStatusFilter(tickets, statusFilter);
      result = _applySearch(result, searchQuery);
      result = _applySort(result, sortOrder);
      return AsyncData(result);
    },
    loading: () => const AsyncLoading(),
    error: (error, stackTrace) => AsyncError(error, stackTrace),
  );
});

List<Ticket> _applySearch(List<Ticket> tickets, String query) {
  final normalizedQuery = query.trim().toLowerCase();

  if (normalizedQuery.isEmpty) {
    return tickets;
  }

  return tickets
      .where(
        (ticket) => ticket.subject.toLowerCase().contains(normalizedQuery),
      )
      .toList();
}

List<Ticket> _applyStatusFilter(List<Ticket> tickets, TicketStatus? status) {
  if (status == null) {
    return tickets;
  }

  return tickets.where((ticket) => ticket.status == status).toList();
}

List<Ticket> _applySort(List<Ticket> tickets, TicketSortOrder sortOrder) {
  final sortedTickets = List<Ticket>.from(tickets);

  sortedTickets.sort((first, second) {
    switch (sortOrder) {
      case TicketSortOrder.newestFirst:
        return second.createdAt.compareTo(first.createdAt);
      case TicketSortOrder.oldestFirst:
        return first.createdAt.compareTo(second.createdAt);
    }
  });

  return sortedTickets;
}
