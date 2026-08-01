import '../entities/ticket.dart';

/// Contract for ticket data operations and business rules.
abstract class TicketRepository {
  Future<String> generateTicketNumber();

  Future<void> createTicket(Ticket ticket);

  Future<List<Ticket>> getTickets();

  Future<Ticket?> getTicketById(String id);

  Future<void> updateTicket(Ticket ticket);

  Future<void> deleteTicket(String id);
}
