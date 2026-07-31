import 'package:flutter/material.dart';

import '../../../../core/utils/date_formatter.dart';
import '../../domain/entities/ticket.dart';
import 'priority_badge.dart';
import 'status_badge.dart';

/// List item card for a ticket.
class TicketCard extends StatelessWidget {
  const TicketCard({
    super.key,
    required this.ticket,
    required this.onTap,
  });

  final Ticket ticket;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    ticket.ticketNumber,
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    Icons.calendar_today_outlined,
                    size: 14,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    DateFormatter.shortDate(ticket.createdAt),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                ticket.subject,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  PriorityBadge(priority: ticket.priority),
                  StatusBadge(status: ticket.status),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
