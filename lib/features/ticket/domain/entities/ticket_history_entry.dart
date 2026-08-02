/// A single audit event for a ticket.
class TicketHistoryEntry {
  const TicketHistoryEntry({
    required this.id,
    required this.ticketId,
    required this.message,
    required this.timestamp,
  });

  final String id;
  final String ticketId;
  final String message;
  final DateTime timestamp;
}
