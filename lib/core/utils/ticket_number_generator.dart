/// Generates human-readable ticket numbers from a sequential counter.
abstract final class TicketNumberGenerator {
  static String format(int number) {
    return 'TKT-${number.toString().padLeft(5, '0')}';
  }

  /// Parses the numeric suffix from a ticket number string.
  static int? parseNumber(String ticketNumber) {
    if (!ticketNumber.startsWith('TKT-')) {
      return null;
    }

    return int.tryParse(ticketNumber.substring(4));
  }
}
