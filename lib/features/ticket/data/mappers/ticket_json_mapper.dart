import '../../domain/entities/ticket.dart';

/// Converts tickets to JSON-friendly maps for export.
abstract final class TicketJsonMapper {
  static Map<String, dynamic> toMap(Ticket ticket) {
    return {
      'id': ticket.id,
      'ticketNumber': ticket.ticketNumber,
      'subject': ticket.subject,
      'description': ticket.description,
      'priority': ticket.priority.name,
      'category': ticket.category.name,
      'status': ticket.status.name,
      'createdAt': ticket.createdAt.toIso8601String(),
      'updatedAt': ticket.updatedAt.toIso8601String(),
    };
  }
}
