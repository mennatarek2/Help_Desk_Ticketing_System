import '../../domain/entities/ticket_history_entry.dart';
import '../models/ticket_history_model.dart';

/// Maps ticket history between entity and Hive model.
abstract final class TicketHistoryMapper {
  static TicketHistoryEntry toEntity(TicketHistoryModel model) {
    return TicketHistoryEntry(
      id: model.id,
      ticketId: model.ticketId,
      message: model.message,
      timestamp: model.timestamp,
    );
  }

  static TicketHistoryModel toModel(TicketHistoryEntry entry) {
    return TicketHistoryModel(
      id: entry.id,
      ticketId: entry.ticketId,
      message: entry.message,
      timestamp: entry.timestamp,
    );
  }
}
