import 'package:hive/hive.dart';

import '../../../../core/constants/hive_type_ids.dart';

part 'ticket_model.g.dart';

/// Hive persistence model for tickets.
///
/// Enum values are stored as indices and mapped in [TicketMapper].
@HiveType(typeId: HiveTypeIds.ticketModel)
class TicketModel {
  const TicketModel({
    required this.id,
    required this.ticketNumber,
    required this.subject,
    required this.description,
    required this.priorityIndex,
    required this.categoryIndex,
    required this.statusIndex,
    required this.createdAt,
    required this.updatedAt,
  });

  @HiveField(0)
  final String id;

  @HiveField(1)
  final String ticketNumber;

  @HiveField(2)
  final String subject;

  @HiveField(3)
  final String description;

  @HiveField(4)
  final int priorityIndex;

  @HiveField(5)
  final int categoryIndex;

  @HiveField(6)
  final int statusIndex;

  @HiveField(7)
  final DateTime createdAt;

  @HiveField(8)
  final DateTime updatedAt;
}
