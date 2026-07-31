import 'package:go_router/go_router.dart';

import '../../../../core/router/route_names.dart';
import '../screens/create_ticket_screen.dart';
import '../screens/dashboard_screen.dart';
import '../screens/ticket_details_screen.dart';
import '../screens/ticket_list_screen.dart';

/// Feature-level route definitions for the ticket module.
abstract final class TicketRoutes {
  static List<RouteBase> get routes => [
        GoRoute(
          path: RouteNames.dashboard,
          name: RouteNames.dashboard,
          builder: (context, state) => const DashboardScreen(),
        ),
        GoRoute(
          path: RouteNames.ticketList,
          name: RouteNames.ticketList,
          builder: (context, state) => const TicketListScreen(),
        ),
        GoRoute(
          path: RouteNames.createTicket,
          name: RouteNames.createTicket,
          builder: (context, state) => const CreateTicketScreen(),
        ),
        GoRoute(
          path: RouteNames.ticketDetails,
          name: RouteNames.ticketDetails,
          builder: (context, state) {
            final ticketId = state.pathParameters['id'] ?? '';
            return TicketDetailsScreen(ticketId: ticketId);
          },
        ),
      ];
}
