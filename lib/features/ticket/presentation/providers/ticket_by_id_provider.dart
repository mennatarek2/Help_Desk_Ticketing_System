import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/ticket.dart';
import 'ticket_list_provider.dart';

/// Resolves a ticket from the current list by id.
final ticketByIdProvider = Provider.family<AsyncValue<Ticket?>, String>(
  (ref, id) {
    final ticketsAsync = ref.watch(ticketListProvider);

    return ticketsAsync.when(
      data: (tickets) {
        for (final ticket in tickets) {
          if (ticket.id == id) {
            return AsyncData(ticket);
          }
        }
        return const AsyncData(null);
      },
      loading: () => const AsyncLoading(),
      error: (error, stackTrace) => AsyncError(error, stackTrace),
    );
  },
);
