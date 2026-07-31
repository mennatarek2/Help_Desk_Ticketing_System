import '../../../../core/widgets/placeholder_screen.dart';

/// Ticket details screen placeholder.
class TicketDetailsScreen extends PlaceholderScreen {
  const TicketDetailsScreen({super.key, required String ticketId})
      : super(title: 'Ticket $ticketId');
}
