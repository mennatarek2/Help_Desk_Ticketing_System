import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/utils/failure_message.dart';
import '../../domain/entities/ticket.dart';
import '../../domain/entities/ticket_category.dart';
import '../../domain/entities/ticket_priority.dart';
import '../../domain/entities/ticket_status.dart';
import 'dependency_providers.dart';
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
      final repository = _ref.read(ticketRepositoryProvider);
      final ticketNumber = await repository.generateTicketNumber();
      final now = DateTime.now();

      final ticket = Ticket(
        id: const Uuid().v4(),
        ticketNumber: ticketNumber,
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
        return CreateTicketFailure(
          resolveFailureMessage(
            state.error,
            fallback: 'Unable to create ticket. Please try again.',
          ),
        );
      }

      return const CreateTicketSuccess();
    } catch (error) {
      return CreateTicketFailure(
        resolveFailureMessage(
          error,
          fallback: 'Unable to create ticket. Please try again.',
        ),
      );
    }
  }
}

/// Provides [CreateTicketController] for the create ticket screen.
final createTicketControllerProvider = Provider<CreateTicketController>(
  (ref) => CreateTicketController(ref),
);
