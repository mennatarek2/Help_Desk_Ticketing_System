import 'package:hive/hive.dart';

import '../../../../core/constants/hive_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/services/hive_service.dart';
import '../../domain/entities/ticket_history_entry.dart';
import '../mappers/ticket_history_mapper.dart';
import '../models/ticket_history_model.dart';
import 'ticket_history_local_datasource.dart';

/// Hive-backed implementation of [TicketHistoryLocalDataSource].
class TicketHistoryLocalDataSourceImpl implements TicketHistoryLocalDataSource {
  TicketHistoryLocalDataSourceImpl(this._hiveService);

  final HiveService _hiveService;

  Box<TicketHistoryModel> get _historyBox =>
      Hive.box<TicketHistoryModel>(HiveConstants.historyBoxName);

  void _ensureInitialized() {
    if (!_hiveService.isInitialized) {
      throw const CacheException('Local storage is not initialized.');
    }
  }

  @override
  Future<void> addEntry(TicketHistoryEntry entry) async {
    _ensureInitialized();

    try {
      await _historyBox.put(entry.id, TicketHistoryMapper.toModel(entry));
    } catch (_) {
      throw const CacheException('Failed to save ticket history.');
    }
  }

  @override
  Future<List<TicketHistoryEntry>> getEntriesForTicket(String ticketId) async {
    _ensureInitialized();

    try {
      return _historyBox.values
          .where((entry) => entry.ticketId == ticketId)
          .map(TicketHistoryMapper.toEntity)
          .toList()
        ..sort((first, second) => second.timestamp.compareTo(first.timestamp));
    } catch (_) {
      throw const CacheException('Failed to read ticket history.');
    }
  }

  @override
  Future<void> deleteEntriesForTicket(String ticketId) async {
    _ensureInitialized();

    try {
      final keysToDelete = _historyBox.values
          .where((entry) => entry.ticketId == ticketId)
          .map((entry) => entry.id)
          .toList();

      await _historyBox.deleteAll(keysToDelete);
    } catch (_) {
      throw const CacheException('Failed to delete ticket history.');
    }
  }
}
