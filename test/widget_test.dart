import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:help_desk_ticketing_system/app.dart';
import 'package:help_desk_ticketing_system/core/providers/theme_mode_provider.dart';
import 'package:help_desk_ticketing_system/features/ticket/domain/entities/ticket.dart';
import 'package:help_desk_ticketing_system/features/ticket/presentation/providers/ticket_list_provider.dart';

void main() {
  testWidgets('App loads dashboard with statistics', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          ticketListProvider.overrideWith(_EmptyTicketListNotifier.new),
          themeModeProvider.overrideWith(_LightThemeModeNotifier.new),
        ],
        child: const App(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Dashboard'), findsOneWidget);
    expect(find.text('Overview'), findsOneWidget);
    expect(find.text('Total Tickets'), findsOneWidget);
    expect(find.text('Open'), findsOneWidget);
    expect(find.text('In Progress'), findsOneWidget);
    expect(find.text('Closed'), findsOneWidget);
  });
}

class _EmptyTicketListNotifier extends TicketListNotifier {
  @override
  Future<List<Ticket>> build() async => [];
}

class _LightThemeModeNotifier extends ThemeModeNotifier {
  @override
  Future<ThemeMode> build() async => ThemeMode.light;
}
