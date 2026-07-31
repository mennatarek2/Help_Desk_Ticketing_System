import '../entities/ticket.dart';
import '../entities/ticket_sort_order.dart';
import '../entities/ticket_status.dart';

/// Contract for ticket data operations and business rules.
abstract class TicketRepository {
  Future<void> createTicket(Ticket ticket);

  Future<List<Ticket>> getTickets();

  Future<Ticket?> getTicketById(String id);

  Future<void> updateTicket(Ticket ticket);

  Future<void> deleteTicket(String id);

  Future<List<Ticket>> searchTickets(String query);

  Future<List<Ticket>> filterTickets({TicketStatus? status});

  Future<List<Ticket>> sortTickets(
    List<Ticket> tickets,
    TicketSortOrder sortOrder,
  );

  /// Applies search, filter, and sort options to an in-memory ticket list.
  List<Ticket> applyListOptions({
    required List<Ticket> tickets,
    String query = '',
    TicketStatus? status,
    TicketSortOrder sortOrder = TicketSortOrder.newestFirst,
  });
}
