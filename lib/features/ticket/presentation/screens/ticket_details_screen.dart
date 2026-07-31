import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/widgets/confirmation_dialog.dart';
import '../../../../core/widgets/custom_dropdown.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/empty_state_widget.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../domain/entities/ticket.dart';
import '../../domain/entities/ticket_priority.dart';
import '../../domain/entities/ticket_status.dart';
import '../providers/ticket_by_id_provider.dart';
import '../providers/ticket_details_controller.dart';
import '../providers/ticket_list_provider.dart';
import '../utils/ticket_form_validators.dart';
import '../widgets/priority_chip.dart';
import '../widgets/status_chip.dart';
import '../widgets/ticket_detail_tile.dart';

/// Displays and edits a single ticket.
class TicketDetailsScreen extends ConsumerStatefulWidget {
  const TicketDetailsScreen({super.key, required this.ticketId});

  final String ticketId;

  @override
  ConsumerState<TicketDetailsScreen> createState() =>
      _TicketDetailsScreenState();
}

class _TicketDetailsScreenState extends ConsumerState<TicketDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _subjectController = TextEditingController();
  final _descriptionController = TextEditingController();

  bool _isEditing = false;
  bool _isSaving = false;
  bool _isDeleting = false;

  TicketPriority _priority = TicketPriority.medium;
  TicketStatus _status = TicketStatus.open;

  @override
  void dispose() {
    _subjectController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _populateForm(Ticket ticket) {
    _subjectController.text = ticket.subject;
    _descriptionController.text = ticket.description;
    _priority = ticket.priority;
    _status = ticket.status;
  }

  void _toggleEdit(Ticket ticket) {
    setState(() {
      if (_isEditing) {
        _populateForm(ticket);
        _isEditing = false;
      } else {
        _populateForm(ticket);
        _isEditing = true;
      }
    });
  }

  Future<void> _save(Ticket ticket) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isSaving = true);

    final updatedTicket = ticket.copyWith(
      subject: _subjectController.text.trim(),
      description: _descriptionController.text.trim(),
      priority: _priority,
      status: _status,
    );

    final result = await ref
        .read(ticketDetailsControllerProvider)
        .updateTicket(updatedTicket);

    if (!mounted) {
      return;
    }

    setState(() {
      _isSaving = false;
      if (result is UpdateTicketSuccess) {
        _isEditing = false;
      }
    });

    switch (result) {
      case UpdateTicketSuccess():
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ticket updated successfully')),
        );
      case UpdateTicketFailure(:final message):
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
    }
  }

  Future<void> _delete(Ticket ticket) async {
    final confirmed = await ConfirmationDialog.show(
      context,
      title: 'Delete Ticket',
      message:
          'Are you sure you want to delete ${ticket.ticketNumber}? '
          'This action cannot be undone.',
      confirmLabel: 'Delete',
      cancelLabel: 'Cancel',
    );

    if (!confirmed || !mounted) {
      return;
    }

    setState(() => _isDeleting = true);

    final result = await ref
        .read(ticketDetailsControllerProvider)
        .deleteTicket(ticket.id);

    if (!mounted) {
      return;
    }

    setState(() => _isDeleting = false);

    switch (result) {
      case DeleteTicketSuccess():
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ticket deleted successfully')),
        );
        context.pop();
      case DeleteTicketFailure(:final message):
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final ticketAsync = ref.watch(ticketByIdProvider(widget.ticketId));

    return ticketAsync.when(
      data: (ticket) {
        if (ticket == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Ticket Details')),
            body: EmptyStateWidget(
              icon: Icons.search_off_rounded,
              title: 'Ticket not found',
              message: 'This ticket may have been deleted.',
              action: PrimaryButton(
                label: 'Go Back',
                icon: Icons.arrow_back_rounded,
                onPressed: () => context.pop(),
              ),
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(ticket.ticketNumber),
            actions: [
              if (!_isEditing)
                IconButton(
                  tooltip: 'Edit ticket',
                  onPressed: () => _toggleEdit(ticket),
                  icon: const Icon(Icons.edit_rounded),
                ),
              if (_isEditing)
                TextButton(
                  onPressed: _isSaving ? null : () => _toggleEdit(ticket),
                  child: const Text('Cancel'),
                ),
            ],
          ),
          body: _isEditing
              ? _EditTicketForm(
                  formKey: _formKey,
                  subjectController: _subjectController,
                  descriptionController: _descriptionController,
                  priority: _priority,
                  status: _status,
                  onPriorityChanged: (value) {
                    if (value != null) {
                      setState(() => _priority = value);
                    }
                  },
                  onStatusChanged: (value) {
                    if (value != null) {
                      setState(() => _status = value);
                    }
                  },
                )
              : _TicketDetailsView(ticket: ticket),
          bottomNavigationBar: _TicketDetailsActions(
            ticket: ticket,
            isEditing: _isEditing,
            isSaving: _isSaving,
            isDeleting: _isDeleting,
            onSave: () => _save(ticket),
            onDelete: () => _delete(ticket),
          ),
        );
      },
      loading: () => Scaffold(
        appBar: AppBar(title: const Text('Ticket Details')),
        body: const LoadingWidget(message: 'Loading ticket...'),
      ),
      error: (error, _) => Scaffold(
        appBar: AppBar(title: const Text('Ticket Details')),
        body: EmptyStateWidget(
          icon: Icons.error_outline_rounded,
          title: 'Unable to load ticket',
          message: error.toString(),
          action: PrimaryButton(
            label: 'Try Again',
            icon: Icons.refresh_rounded,
            onPressed: () =>
                ref.read(ticketListProvider.notifier).refresh(),
          ),
        ),
      ),
    );
  }
}

class _TicketDetailsView extends StatelessWidget {
  const _TicketDetailsView({required this.ticket});

  final Ticket ticket;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            PriorityChip(priority: ticket.priority),
            StatusChip(status: ticket.status),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        TicketDetailTile(label: 'Ticket Number', value: ticket.ticketNumber),
        TicketDetailTile(label: 'Subject', value: ticket.subject),
        TicketDetailTile(label: 'Description', value: ticket.description),
        TicketDetailTile(label: 'Priority', value: ticket.priority.label),
        TicketDetailTile(label: 'Category', value: ticket.category.label),
        TicketDetailTile(label: 'Status', value: ticket.status.label),
        TicketDetailTile(
          label: 'Created Date',
          value: DateFormatter.display(ticket.createdAt),
        ),
        TicketDetailTile(
          label: 'Last Updated',
          value: DateFormatter.display(ticket.updatedAt),
        ),
      ],
    );
  }
}

class _EditTicketForm extends StatelessWidget {
  const _EditTicketForm({
    required this.formKey,
    required this.subjectController,
    required this.descriptionController,
    required this.priority,
    required this.status,
    required this.onPriorityChanged,
    required this.onStatusChanged,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController subjectController;
  final TextEditingController descriptionController;
  final TicketPriority priority;
  final TicketStatus status;
  final ValueChanged<TicketPriority?> onPriorityChanged;
  final ValueChanged<TicketStatus?> onStatusChanged;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          CustomTextField(
            controller: subjectController,
            label: 'Subject',
            hint: 'Brief summary of the issue',
            validator: TicketFormValidators.subject,
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: AppSpacing.md),
          CustomTextField(
            controller: descriptionController,
            label: 'Description',
            hint: 'Describe the issue in detail',
            validator: TicketFormValidators.description,
            maxLines: 5,
          ),
          const SizedBox(height: AppSpacing.md),
          CustomDropdown<TicketPriority>(
            label: 'Priority',
            value: priority,
            items: TicketPriority.values,
            itemLabel: (item) => item.label,
            onChanged: onPriorityChanged,
          ),
          const SizedBox(height: AppSpacing.md),
          CustomDropdown<TicketStatus>(
            label: 'Status',
            value: status,
            items: TicketStatus.values,
            itemLabel: (item) => item.label,
            onChanged: onStatusChanged,
          ),
        ],
      ),
    );
  }
}

class _TicketDetailsActions extends StatelessWidget {
  const _TicketDetailsActions({
    required this.ticket,
    required this.isEditing,
    required this.isSaving,
    required this.isDeleting,
    required this.onSave,
    required this.onDelete,
  });

  final Ticket ticket;
  final bool isEditing;
  final bool isSaving;
  final bool isDeleting;
  final VoidCallback onSave;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isEditing)
              PrimaryButton(
                label: isSaving ? 'Saving...' : 'Save Changes',
                icon: Icons.save_rounded,
                isLoading: isSaving,
                expand: true,
                onPressed: isSaving ? null : onSave,
              ),
            if (!isEditing) ...[
              OutlinedButton.icon(
                onPressed: isDeleting ? null : onDelete,
                style: OutlinedButton.styleFrom(
                  foregroundColor: theme.colorScheme.error,
                  side: BorderSide(color: theme.colorScheme.error),
                  minimumSize: const Size.fromHeight(48),
                ),
                icon: isDeleting
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.delete_outline_rounded),
                label: Text(isDeleting ? 'Deleting...' : 'Delete Ticket'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
