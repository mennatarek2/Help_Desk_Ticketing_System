import 'package:hive/hive.dart';

import '../../../../core/constants/hive_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/services/hive_service.dart';
import '../../../../core/utils/ticket_number_generator.dart';
import '../../domain/entities/ticket.dart';
import 'ticket_settings_local_datasource.dart';

/// Hive-backed implementation of [TicketSettingsLocalDataSource].
class TicketSettingsLocalDataSourceImpl implements TicketSettingsLocalDataSource {
  TicketSettingsLocalDataSourceImpl(this._hiveService);

  final HiveService _hiveService;

  Box get _settingsBox => Hive.box(HiveConstants.settingsBoxName);

  void _ensureInitialized() {
    if (!_hiveService.isInitialized) {
      throw const CacheException('Local storage is not initialized.');
    }
  }

  @override
  Future<int> getNextTicketNumber() async {
    _ensureInitialized();

    try {
      final value = _settingsBox.get(HiveConstants.nextTicketNumberKey);
      if (value is! int) {
        throw const CacheException('Ticket counter is not initialized.');
      }

      return value;
    } catch (error) {
      if (error is CacheException) {
        rethrow;
      }
      throw const CacheException('Failed to read ticket counter.');
    }
  }

  @override
  Future<void> incrementTicketNumber() async {
    _ensureInitialized();

    try {
      final current = await getNextTicketNumber();
      await _settingsBox.put(HiveConstants.nextTicketNumberKey, current + 1);
    } catch (error) {
      if (error is CacheException) {
        rethrow;
      }
      throw const CacheException('Failed to update ticket counter.');
    }
  }

  @override
  Future<void> initializeCounterFromTickets(List<Ticket> tickets) async {
    _ensureInitialized();

    if (_settingsBox.containsKey(HiveConstants.nextTicketNumberKey)) {
      return;
    }

    var highestNumber = 0;

    for (final ticket in tickets) {
      final parsed = TicketNumberGenerator.parseNumber(ticket.ticketNumber);
      if (parsed != null && parsed > highestNumber) {
        highestNumber = parsed;
      }
    }

    await _settingsBox.put(
      HiveConstants.nextTicketNumberKey,
      highestNumber + 1,
    );
  }
}
