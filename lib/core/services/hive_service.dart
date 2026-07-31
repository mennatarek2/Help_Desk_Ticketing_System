import 'package:hive_flutter/hive_flutter.dart';

import '../../features/ticket/data/adapters/hive_adapters.dart';
import '../../features/ticket/data/models/ticket_model.dart';
import '../constants/hive_constants.dart';

/// Handles Hive initialization and box lifecycle.
class HiveService {
  HiveService();

  bool _isInitialized = false;

  bool get isInitialized => _isInitialized;

  /// Initializes Hive and opens required boxes.
  Future<void> init() async {
    if (_isInitialized) {
      return;
    }

    await Hive.initFlutter();
    _registerAdapters();
    await _openBoxes();

    _isInitialized = true;
  }

  void _registerAdapters() {
    registerTicketHiveAdapters();
  }

  Future<void> _openBoxes() async {
    await Hive.openBox<TicketModel>(HiveConstants.ticketBoxName);
  }
}
