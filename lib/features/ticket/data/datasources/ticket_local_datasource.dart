import '../../domain/entities/ticket.dart';

/// Contract for local ticket persistence.
///
/// Storage operations only — business rules belong in [TicketRepository].
abstract class TicketLocalDataSource {
  Future<List<Ticket>> getAllTickets();

  Future<Ticket?> getTicketById(String id);

  Future<void> saveTicket(Ticket ticket);

  Future<void> deleteTicket(String id);
}
