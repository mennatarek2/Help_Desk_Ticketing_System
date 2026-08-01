import 'package:flutter/material.dart';

import '../utils/failure_message.dart';
import 'empty_state_widget.dart';
import 'primary_button.dart';

/// Shared error view for async provider failures with retry support.
class AsyncErrorView extends StatelessWidget {
  const AsyncErrorView({
    super.key,
    required this.title,
    required this.error,
    required this.onRetry,
    this.fallbackMessage,
  });

  final String title;
  final Object error;
  final VoidCallback onRetry;
  final String? fallbackMessage;

  @override
  Widget build(BuildContext context) {
    return EmptyStateWidget(
      icon: Icons.error_outline_rounded,
      title: title,
      message: resolveFailureMessage(
        error,
        fallback: fallbackMessage ??
            'Something went wrong. Please try again.',
      ),
      action: PrimaryButton(
        label: 'Try Again',
        icon: Icons.refresh_rounded,
        onPressed: onRetry,
      ),
    );
  }
}
