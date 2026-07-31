import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Manages the ticket search query.
class TicketSearchNotifier extends Notifier<String> {
  @override
  String build() => '';

  void updateQuery(String query) {
    state = query;
  }

  void clear() {
    state = '';
  }
}

/// Current search query for filtering tickets by subject.
final ticketSearchProvider = NotifierProvider<TicketSearchNotifier, String>(
  TicketSearchNotifier.new,
);
