import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../features/ticket/data/adapters/hive_adapters.dart';
import '../../features/ticket/data/models/ticket_history_model.dart';
import '../../features/ticket/data/models/ticket_model.dart';
import '../constants/hive_constants.dart';
import '../errors/exceptions.dart';

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

    try {
      await Hive.initFlutter();
      _registerAdapters();
      await _openBoxes();
      _isInitialized = true;
    } catch (error, stackTrace) {
      _isInitialized = false;
      debugPrint('Hive initialization failed: $error');
      debugPrintStack(stackTrace: stackTrace);

      throw CacheException(
        'Failed to initialize local storage. Please restart the app.',
      );
    }
  }

  void _registerAdapters() {
    registerTicketHiveAdapters();
  }

  Future<void> _openBoxes() async {
    await Hive.openBox<TicketModel>(HiveConstants.ticketBoxName);
    await Hive.openBox<TicketHistoryModel>(HiveConstants.historyBoxName);
    await Hive.openBox(HiveConstants.settingsBoxName);
  }
}
