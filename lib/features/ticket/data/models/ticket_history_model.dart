import 'package:hive/hive.dart';

import '../../../../core/constants/hive_type_ids.dart';

part 'ticket_history_model.g.dart';

/// Hive persistence model for ticket history entries.
@HiveType(typeId: HiveTypeIds.ticketHistoryModel)
class TicketHistoryModel {
  const TicketHistoryModel({
    required this.id,
    required this.ticketId,
    required this.message,
    required this.timestamp,
  });

  @HiveField(0)
  final String id;

  @HiveField(1)
  final String ticketId;

  @HiveField(2)
  final String message;

  @HiveField(3)
  final DateTime timestamp;
}
