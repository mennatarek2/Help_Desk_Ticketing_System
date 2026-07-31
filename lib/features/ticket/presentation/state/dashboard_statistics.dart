import '../../domain/entities/ticket.dart';
import '../../domain/entities/ticket_status.dart';

/// Dashboard summary counts derived from ticket data.
class DashboardStatistics {
  const DashboardStatistics({
    required this.total,
    required this.open,
    required this.inProgress,
    required this.closed,
  });

  const DashboardStatistics.empty()
      : total = 0,
        open = 0,
        inProgress = 0,
        closed = 0;

  final int total;
  final int open;
  final int inProgress;
  final int closed;

  factory DashboardStatistics.fromTickets(List<Ticket> tickets) {
    var open = 0;
    var inProgress = 0;
    var closed = 0;

    for (final ticket in tickets) {
      switch (ticket.status) {
        case TicketStatus.open:
          open++;
        case TicketStatus.inProgress:
          inProgress++;
        case TicketStatus.closed:
          closed++;
      }
    }

    return DashboardStatistics(
      total: tickets.length,
      open: open,
      inProgress: inProgress,
      closed: closed,
    );
  }
}
