import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/ticket/presentation/router/ticket_routes.dart';
import 'route_names.dart';

/// Provides the application [GoRouter] instance.
final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: RouteNames.dashboard,
    debugLogDiagnostics: false,
    routes: TicketRoutes.routes,
  );
});
