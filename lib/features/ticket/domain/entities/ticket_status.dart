/// Ticket lifecycle statuses.
enum TicketStatus {
  open('Open'),
  inProgress('In Progress'),
  closed('Closed');

  const TicketStatus(this.label);

  final String label;
}
