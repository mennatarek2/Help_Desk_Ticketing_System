import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/utils/ticket_number_generator.dart';
import '../../domain/entities/ticket.dart';
import '../../domain/entities/ticket_category.dart';
import '../../domain/entities/ticket_priority.dart';
import '../../domain/entities/ticket_status.dart';
import 'ticket_list_provider.dart';

/// Result of a create ticket submission.
sealed class CreateTicketResult {
  const CreateTicketResult();
}

class CreateTicketSuccess extends CreateTicketResult {
  const CreateTicketSuccess();
}

class CreateTicketFailure extends CreateTicketResult {
  const CreateTicketFailure(this.message);

  final String message;
}

/// Handles create ticket business orchestration.
class CreateTicketController {
  CreateTicketController(this._ref);

  final Ref _ref;

  Future<CreateTicketResult> submit({
    required String subject,
    required String description,
    required TicketPriority priority,
    required TicketCategory category,
  }) async {
    try {
      final existingTickets = await _ref.read(ticketListProvider.future);
      final now = DateTime.now();

      final ticket = Ticket(
        id: const Uuid().v4(),
        ticketNumber: TicketNumberGenerator.generate(
          existingCount: existingTickets.length,
        ),
        subject: subject.trim(),
        description: description.trim(),
        priority: priority,
        category: category,
        status: TicketStatus.open,
        createdAt: now,
        updatedAt: now,
      );

      await _ref.read(ticketListProvider.notifier).createTicket(ticket);

      final state = _ref.read(ticketListProvider);
      if (state.hasError) {
        return CreateTicketFailure(_resolveErrorMessage(state.error));
      }

      return const CreateTicketSuccess();
    } catch (error) {
      return CreateTicketFailure(_resolveErrorMessage(error));
    }
  }

  String _resolveErrorMessage(Object? error) {
    if (error is Failure) {
      return error.message;
    }

    return 'Unable to create ticket. Please try again.';
  }
}

/// Provides [CreateTicketController] for the create ticket screen.
final createTicketControllerProvider = Provider<CreateTicketController>(
  (ref) => CreateTicketController(ref),
);
