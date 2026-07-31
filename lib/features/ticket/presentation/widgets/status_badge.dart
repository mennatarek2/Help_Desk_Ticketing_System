import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/ticket_status.dart';
import 'badge_chip.dart';

/// Badge displaying ticket status.
class StatusBadge extends StatelessWidget {
  const StatusBadge({super.key, required this.status});

  final TicketStatus status;

  @override
  Widget build(BuildContext context) {
    return BadgeChip(
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
