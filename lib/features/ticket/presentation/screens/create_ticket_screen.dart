import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../domain/entities/ticket_category.dart';
import '../../domain/entities/ticket_priority.dart';
import '../providers/create_ticket_controller.dart';
import '../utils/ticket_form_validators.dart';

/// Screen for creating a new support ticket.
class CreateTicketScreen extends ConsumerStatefulWidget {
  const CreateTicketScreen({super.key});

  @override
  ConsumerState<CreateTicketScreen> createState() => _CreateTicketScreenState();
}

class _CreateTicketScreenState extends ConsumerState<CreateTicketScreen> {
  final _formKey = GlobalKey<FormState>();
  final _subjectController = TextEditingController();
  final _descriptionController = TextEditingController();

  TicketPriority _priority = TicketPriority.medium;
  TicketCategory _category = TicketCategory.general;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _subjectController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isSubmitting = true);

    final result = await ref.read(createTicketControllerProvider).submit(
          subject: _subjectController.text,
          description: _descriptionController.text,
          priority: _priority,
          category: _category,
        );

    if (!mounted) {
      return;
    }

    setState(() => _isSubmitting = false);

    switch (result) {
      case CreateTicketSuccess():
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ticket created successfully')),
        );
        context.pop();
      case CreateTicketFailure(:final message):
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Ticket'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Text(
              'New Support Ticket',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Fill in the details below. Ticket number and status will be '
              'assigned automatically.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 24),
            TextFormField(
              controller: _subjectController,
              decoration: const InputDecoration(
                labelText: 'Subject',
                hintText: 'Brief summary of the issue',
              ),
              textInputAction: TextInputAction.next,
              validator: TicketFormValidators.subject,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                hintText: 'Describe the issue in detail',
                alignLabelWithHint: true,
              ),
              maxLines: 5,
              validator: TicketFormValidators.description,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<TicketPriority>(
              initialValue: _priority,
              decoration: const InputDecoration(labelText: 'Priority'),
              items: [
                for (final priority in TicketPriority.values)
                  DropdownMenuItem(
                    value: priority,
                    child: Text(priority.label),
                  ),
              ],
              onChanged: _isSubmitting
                  ? null
                  : (value) {
                      if (value != null) {
                        setState(() => _priority = value);
                      }
                    },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<TicketCategory>(
              initialValue: _category,
              decoration: const InputDecoration(labelText: 'Category'),
              items: [
                for (final category in TicketCategory.values)
                  DropdownMenuItem(
                    value: category,
                    child: Text(category.label),
                  ),
              ],
              onChanged: _isSubmitting
                  ? null
                  : (value) {
                      if (value != null) {
                        setState(() => _category = value);
                      }
                    },
            ),
            const SizedBox(height: 32),
            FilledButton.icon(
              onPressed: _isSubmitting ? null : _submit,
              icon: _isSubmitting
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.save_rounded),
              label: Text(_isSubmitting ? 'Saving...' : 'Save Ticket'),
            ),
          ],
        ),
      ),
    );
  }
}
