import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/ticket_priority.dart';
import 'badge_chip.dart';

/// Badge displaying ticket priority.
class PriorityBadge extends StatelessWidget {
  const PriorityBadge({super.key, required this.priority});

  final TicketPriority priority;

  @override
  Widget build(BuildContext context) {
    return BadgeChip(
      label: priority.label,
      color: _colorForPriority(priority),
    );
  }

  Color _colorForPriority(TicketPriority priority) {
    return switch (priority) {
      TicketPriority.low => AppColors.priorityLow,
      TicketPriority.medium => AppColors.priorityMedium,
      TicketPriority.high => AppColors.priorityHigh,
    };
  }
}
