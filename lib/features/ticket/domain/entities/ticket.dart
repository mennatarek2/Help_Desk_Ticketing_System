import 'ticket_category.dart';
import 'ticket_priority.dart';
import 'ticket_status.dart';

/// Core ticket entity used across the domain layer.
///
/// This class is independent of any persistence framework.
class Ticket {
  const Ticket({
    required this.id,
    required this.ticketNumber,
    required this.subject,
    required this.description,
    required this.priority,
    required this.category,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String ticketNumber;
  final String subject;
  final String description;
  final TicketPriority priority;
  final TicketCategory category;
  final TicketStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;

  Ticket copyWith({
    String? id,
    String? ticketNumber,
    String? subject,
    String? description,
    TicketPriority? priority,
    TicketCategory? category,
    TicketStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Ticket(
      id: id ?? this.id,
      ticketNumber: ticketNumber ?? this.ticketNumber,
      subject: subject ?? this.subject,
      description: description ?? this.description,
      priority: priority ?? this.priority,
      category: category ?? this.category,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
