import '../../domain/entities/ticket_history_entry.dart';

/// Contract for ticket history persistence.
abstract class TicketHistoryLocalDataSource {
  Future<void> addEntry(TicketHistoryEntry entry);

  Future<List<TicketHistoryEntry>> getEntriesForTicket(String ticketId);

  Future<void> deleteEntriesForTicket(String ticketId);
}
