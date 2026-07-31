/// Ticket priority levels.
enum TicketPriority {
  low('Low'),
  medium('Medium'),
  high('High');

  const TicketPriority(this.label);

  final String label;
}
