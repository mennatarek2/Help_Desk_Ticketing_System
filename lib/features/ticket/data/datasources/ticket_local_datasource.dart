import '../../domain/entities/ticket.dart';

/// Contract for local ticket persistence.
///
/// This layer is responsible for storage operations only.
/// Business rules belong in [TicketRepository].
abstract class TicketLocalDataSource {
  Future<List<Ticket>> getAllTickets();

  Future<Ticket?> getTicketById(String id);

  Future<void> saveTicket(Ticket ticket);

  Future<void> deleteTicket(String id);
}
