import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/custom_dropdown.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/form_content_wrapper.dart';
import '../../../../core/widgets/primary_button.dart';
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
      body: FormContentWrapper(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            children: [
            Text(
              'New Support Ticket',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Fill in the details below. Ticket number and status will be '
              'assigned automatically.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: AppSpacing.lg),
            CustomTextField(
              controller: _subjectController,
              label: 'Subject',
              hint: 'Brief summary of the issue',
              validator: TicketFormValidators.subject,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: AppSpacing.md),
            CustomTextField(
              controller: _descriptionController,
              label: 'Description',
              hint: 'Describe the issue in detail',
              validator: TicketFormValidators.description,
              maxLines: 5,
            ),
            const SizedBox(height: AppSpacing.md),
            CustomDropdown<TicketPriority>(
              label: 'Priority',
              value: _priority,
              items: TicketPriority.values,
              itemLabel: (item) => item.label,
              onChanged: _isSubmitting
                  ? null
                  : (value) {
                      if (value != null) {
                        setState(() => _priority = value);
                      }
                    },
            ),
            const SizedBox(height: AppSpacing.md),
            CustomDropdown<TicketCategory>(
              label: 'Category',
              value: _category,
              items: TicketCategory.values,
              itemLabel: (item) => item.label,
              onChanged: _isSubmitting
                  ? null
                  : (value) {
                      if (value != null) {
                        setState(() => _category = value);
                      }
                    },
            ),
            const SizedBox(height: AppSpacing.xl),
            PrimaryButton(
              label: _isSubmitting ? 'Saving...' : 'Save Ticket',
              icon: Icons.save_rounded,
              isLoading: _isSubmitting,
              expand: true,
              onPressed: _isSubmitting ? null : _submit,
            ),
            ],
          ),
        ),
      ),
    );
  }
}
