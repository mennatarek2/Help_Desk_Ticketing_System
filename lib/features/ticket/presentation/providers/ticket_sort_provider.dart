import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/ticket_sort_order.dart';

/// Manages the active ticket sort order.
class TicketSortNotifier extends Notifier<TicketSortOrder> {
  @override
  TicketSortOrder build() => TicketSortOrder.newestFirst;

  void updateSortOrder(TicketSortOrder sortOrder) {
    state = sortOrder;
  }
}

/// Current sort order for ticket lists.
final ticketSortProvider = NotifierProvider<TicketSortNotifier, TicketSortOrder>(
  TicketSortNotifier.new,
);
