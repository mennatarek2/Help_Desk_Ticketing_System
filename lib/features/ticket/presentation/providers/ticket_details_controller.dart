import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/failure_message.dart';
import '../../domain/entities/ticket.dart';
import 'ticket_list_provider.dart';

/// Result of updating a ticket.
sealed class UpdateTicketResult {
  const UpdateTicketResult();
}

class UpdateTicketSuccess extends UpdateTicketResult {
  const UpdateTicketSuccess();
}

class UpdateTicketFailure extends UpdateTicketResult {
  const UpdateTicketFailure(this.message);

  final String message;
}

/// Result of deleting a ticket.
sealed class DeleteTicketResult {
  const DeleteTicketResult();
}

class DeleteTicketSuccess extends DeleteTicketResult {
  const DeleteTicketSuccess();
}

class DeleteTicketFailure extends DeleteTicketResult {
  const DeleteTicketFailure(this.message);

  final String message;
}

/// Handles ticket update and delete orchestration.
class TicketDetailsController {
  TicketDetailsController(this._ref);

  final Ref _ref;

  Future<UpdateTicketResult> updateTicket(Ticket ticket) async {
    try {
      await _ref.read(ticketListProvider.notifier).updateTicket(ticket);

      final state = _ref.read(ticketListProvider);
      if (state.hasError) {
        return UpdateTicketFailure(
          resolveFailureMessage(state.error),
        );
      }

      return const UpdateTicketSuccess();
    } catch (error) {
      return UpdateTicketFailure(resolveFailureMessage(error));
    }
  }

  Future<DeleteTicketResult> deleteTicket(String id) async {
    try {
      await _ref.read(ticketListProvider.notifier).deleteTicket(id);

      final state = _ref.read(ticketListProvider);
      if (state.hasError) {
        return DeleteTicketFailure(
          resolveFailureMessage(state.error),
        );
      }

      return const DeleteTicketSuccess();
    } catch (error) {
      return DeleteTicketFailure(resolveFailureMessage(error));
    }
  }
}

/// Provides [TicketDetailsController] for the details screen.
final ticketDetailsControllerProvider = Provider<TicketDetailsController>(
  (ref) => TicketDetailsController(ref),
);
