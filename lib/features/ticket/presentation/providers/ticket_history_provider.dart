import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/ticket_history_entry.dart';
import 'dependency_providers.dart';

/// Loads history entries for a single ticket.
final ticketHistoryProvider =
    FutureProvider.family<List<TicketHistoryEntry>, String>((ref, ticketId) {
  final repository = ref.watch(ticketRepositoryProvider);
  return repository.getTicketHistory(ticketId);
});
