import 'package:hive/hive.dart';

import '../../../../core/constants/hive_type_ids.dart';
import '../models/ticket_model.dart';

/// Registers all Hive adapters required by the ticket feature.
void registerTicketHiveAdapters() {
  if (!Hive.isAdapterRegistered(HiveTypeIds.ticketModel)) {
    Hive.registerAdapter(TicketModelAdapter());
  }
}
