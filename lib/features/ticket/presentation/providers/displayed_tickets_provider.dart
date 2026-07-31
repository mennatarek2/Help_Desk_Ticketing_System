import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/ticket.dart';
import 'dependency_providers.dart';
import 'ticket_filter_provider.dart';
import 'ticket_list_provider.dart';
import 'ticket_search_provider.dart';
import 'ticket_sort_provider.dart';

/// Applies search, filter, and sort on top of the ticket list.
final displayedTicketsProvider = FutureProvider<List<Ticket>>((ref) async {
  ref.watch(ticketListProvider);

  final searchQuery = ref.watch(ticketSearchProvider);
  final statusFilter = ref.watch(ticketFilterProvider);
  final sortOrder = ref.watch(ticketSortProvider);
  final repository = ref.watch(ticketRepositoryProvider);

  return repository.queryTickets(
    searchQuery: searchQuery,
    status: statusFilter,
    sortOrder: sortOrder,
  );
});
