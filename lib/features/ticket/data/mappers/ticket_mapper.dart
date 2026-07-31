import '../../domain/entities/ticket.dart';
import '../../domain/entities/ticket_category.dart';
import '../../domain/entities/ticket_priority.dart';
import '../../domain/entities/ticket_status.dart';
import '../models/ticket_model.dart';

/// Maps between [TicketModel] and the domain [Ticket] entity.
abstract final class TicketMapper {
  static Ticket toEntity(TicketModel model) {
    return Ticket(
      id: model.id,
      ticketNumber: model.ticketNumber,
      subject: model.subject,
      description: model.description,
      priority: TicketPriority.values[model.priorityIndex],
      category: TicketCategory.values[model.categoryIndex],
      status: TicketStatus.values[model.statusIndex],
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
    );
  }

  static TicketModel toModel(Ticket entity) {
    return TicketModel(
      id: entity.id,
      ticketNumber: entity.ticketNumber,
      subject: entity.subject,
      description: entity.description,
      priorityIndex: entity.priority.index,
      categoryIndex: entity.category.index,
      statusIndex: entity.status.index,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }
}
