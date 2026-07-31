import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/ticket_status.dart';

/// Manages the active ticket status filter.
class TicketFilterNotifier extends Notifier<TicketStatus?> {
  @override
  TicketStatus? build() => null;

  void updateFilter(TicketStatus? status) {
    state = status;
  }

  void clear() {
    state = null;
  }
}

/// Current status filter. `null` means all statuses.
final ticketFilterProvider =
    NotifierProvider<TicketFilterNotifier, TicketStatus?>(
  TicketFilterNotifier.new,
);
