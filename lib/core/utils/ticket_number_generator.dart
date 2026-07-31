/// Generates human-readable ticket numbers.
abstract final class TicketNumberGenerator {
  static String generate({required int existingCount}) {
    final nextNumber = existingCount + 1;
    return 'TKT-${nextNumber.toString().padLeft(5, '0')}';
  }
}
