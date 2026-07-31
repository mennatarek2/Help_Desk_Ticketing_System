import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:help_desk_ticketing_system/app.dart';

void main() {
  testWidgets('App loads dashboard placeholder', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: App(),
      ),
    );
    await tester.pump();

    expect(find.text('Dashboard'), findsOneWidget);
  });
}
