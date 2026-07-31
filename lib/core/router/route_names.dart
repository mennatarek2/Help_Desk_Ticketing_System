/// Named route paths for [GoRouter].
abstract final class RouteNames {
  static const String dashboard = '/';
  static const String ticketList = '/tickets';
  static const String createTicket = '/tickets/create';
  static const String ticketDetails = '/tickets/:id';

  static String ticketDetailsPath(String id) => '/tickets/$id';
}
