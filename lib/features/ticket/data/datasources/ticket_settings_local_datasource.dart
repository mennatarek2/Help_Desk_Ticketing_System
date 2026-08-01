import '../../domain/entities/ticket.dart';

/// Contract for persistent app settings stored in Hive.
abstract class TicketSettingsLocalDataSource {
  /// Returns the next ticket number to assign (without incrementing).
  Future<int> getNextTicketNumber();

  /// Increments the counter after a ticket is successfully created.
  Future<void> incrementTicketNumber();

  /// Initializes the counter from existing tickets when no value is stored.
  Future<void> initializeCounterFromTickets(List<Ticket> tickets);
}
