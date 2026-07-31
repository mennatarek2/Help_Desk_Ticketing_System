import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/ticket.dart';
import 'dependency_providers.dart';

/// Loads and manages the canonical ticket list.
class TicketListNotifier extends AsyncNotifier<List<Ticket>> {
  @override
  Future<List<Ticket>> build() async {
    final repository = ref.watch(ticketRepositoryProvider);
    return repository.getTickets();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(ticketRepositoryProvider);
      return repository.getTickets();
    });
  }

  Future<void> createTicket(Ticket ticket) async {
    state = await AsyncValue.guard(() async {
      final repository = ref.read(ticketRepositoryProvider);
      await repository.createTicket(ticket);
      return repository.getTickets();
    });
  }

  Future<void> updateTicket(Ticket ticket) async {
    state = await AsyncValue.guard(() async {
      final repository = ref.read(ticketRepositoryProvider);
      await repository.updateTicket(ticket);
      return repository.getTickets();
    });
  }

  Future<void> deleteTicket(String id) async {
    state = await AsyncValue.guard(() async {
      final repository = ref.read(ticketRepositoryProvider);
      await repository.deleteTicket(id);
      return repository.getTickets();
    });
  }

  Future<Ticket?> getTicketById(String id) async {
    final repository = ref.read(ticketRepositoryProvider);
    return repository.getTicketById(id);
  }
}

/// Provides the full ticket list from local storage.
final ticketListProvider =
    AsyncNotifierProvider<TicketListNotifier, List<Ticket>>(
  TicketListNotifier.new,
);
