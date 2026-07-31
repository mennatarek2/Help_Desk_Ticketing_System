import 'package:hive/hive.dart';

import '../../../../core/constants/hive_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/services/hive_service.dart';
import '../../domain/entities/ticket.dart';
import '../mappers/ticket_mapper.dart';
import '../models/ticket_model.dart';
import 'ticket_local_datasource.dart';

/// Hive-backed implementation of [TicketLocalDataSource].
class TicketLocalDataSourceImpl implements TicketLocalDataSource {
  TicketLocalDataSourceImpl(this._hiveService);

  final HiveService _hiveService;

  Box<TicketModel> get _ticketBox =>
      Hive.box<TicketModel>(HiveConstants.ticketBoxName);

  void _ensureInitialized() {
    if (!_hiveService.isInitialized) {
      throw const CacheException('Local storage is not initialized.');
    }
  }

  @override
  Future<List<Ticket>> getAllTickets() async {
    _ensureInitialized();

    try {
      return _ticketBox.values.map(TicketMapper.toEntity).toList();
    } catch (_) {
      throw const CacheException('Failed to read tickets from local storage.');
    }
  }

  @override
  Future<Ticket?> getTicketById(String id) async {
    _ensureInitialized();

    try {
      final ticket = _ticketBox.get(id);
      return ticket == null ? null : TicketMapper.toEntity(ticket);
    } catch (_) {
      throw const CacheException('Failed to read ticket from local storage.');
    }
  }

  @override
  Future<void> saveTicket(Ticket ticket) async {
    _ensureInitialized();

    try {
      await _ticketBox.put(ticket.id, TicketMapper.toModel(ticket));
    } catch (_) {
      throw const CacheException('Failed to save ticket to local storage.');
    }
  }

  @override
  Future<void> deleteTicket(String id) async {
    _ensureInitialized();

    try {
      await _ticketBox.delete(id);
    } catch (_) {
      throw const CacheException('Failed to delete ticket from local storage.');
    }
  }
}
