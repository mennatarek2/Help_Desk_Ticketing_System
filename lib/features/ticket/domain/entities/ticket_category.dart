/// Ticket classification categories.
enum TicketCategory {
  technical('Technical'),
  billing('Billing'),
  general('General');

  const TicketCategory(this.label);

  final String label;
}
