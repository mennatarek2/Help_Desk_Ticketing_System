import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/colored_chip.dart';
import '../../domain/entities/ticket_status.dart';

/// Chip displaying ticket status.
class StatusChip extends StatelessWidget {
  const StatusChip({super.key, required this.status});

  final TicketStatus status;

  @override
  Widget build(BuildContext context) {
    return ColoredChip(
      label: status.label,
      color: _colorForStatus(status),
    );
  }

  Color _colorForStatus(TicketStatus status) {
    return switch (status) {
      TicketStatus.open => AppColors.open,
      TicketStatus.inProgress => AppColors.inProgress,
      TicketStatus.closed => AppColors.closed,
    };
  }
}
