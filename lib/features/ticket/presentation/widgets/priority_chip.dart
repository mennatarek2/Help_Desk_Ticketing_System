import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/colored_chip.dart';
import '../../domain/entities/ticket_priority.dart';

/// Chip displaying ticket priority.
class PriorityChip extends StatelessWidget {
  const PriorityChip({super.key, required this.priority});

  final TicketPriority priority;

  @override
  Widget build(BuildContext context) {
    return ColoredChip(
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
