import 'dart:convert';

import 'package:uuid/uuid.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/utils/ticket_number_generator.dart';
import '../../domain/entities/ticket.dart';
import '../../domain/entities/ticket_history_entry.dart';
import '../../domain/repositories/ticket_repository.dart';
import '../datasources/ticket_history_local_datasource.dart';
import '../datasources/ticket_local_datasource.dart';
import '../datasources/ticket_settings_local_datasource.dart';
import '../mappers/ticket_json_mapper.dart';

/// Concrete implementation of [TicketRepository].
class TicketRepositoryImpl implements TicketRepository {
  TicketRepositoryImpl(
    this._localDataSource,
    this._settingsDataSource,
    this._historyDataSource,
  );

  final TicketLocalDataSource _localDataSource;
  final TicketSettingsLocalDataSource _settingsDataSource;
  final TicketHistoryLocalDataSource _historyDataSource;

  static const _uuid = Uuid();

  @override
  Future<String> generateTicketNumber() async {
    try {
      await _ensureCounterInitialized();
      final nextNumber = await _settingsDataSource.getNextTicketNumber();
      return TicketNumberGenerator.format(nextNumber);
    } on CacheException catch (error) {
      throw CacheFailure(error.message ?? 'Unable to access local storage.');
    }
  }

  @override
  Future<void> createTicket(Ticket ticket) async {
    try {
      _validateTicket(ticket);

      final existingTicket = await _localDataSource.getTicketById(ticket.id);
      if (existingTicket != null) {
        throw const ValidationFailure('A ticket with this id already exists.');
      }

      await _localDataSource.saveTicket(ticket);
      await _settingsDataSource.incrementTicketNumber();
      await _recordHistory(
        ticketId: ticket.id,
        message: 'Ticket created',
      );
    } on Failure {
      rethrow;
    } on CacheException catch (error) {
      throw CacheFailure(error.message ?? 'Unable to access local storage.');
    }
  }

  @override
  Future<List<Ticket>> getTickets() async {
    try {
      return await _localDataSource.getAllTickets();
    } on CacheException catch (error) {
      throw CacheFailure(error.message ?? 'Unable to access local storage.');
    }
  }

  @override
  Future<Ticket?> getTicketById(String id) async {
    try {
      if (id.trim().isEmpty) {
        throw const ValidationFailure('Ticket id is required.');
      }

      return await _localDataSource.getTicketById(id);
    } on Failure {
      rethrow;
    } on CacheException catch (error) {
      throw CacheFailure(error.message ?? 'Unable to access local storage.');
    }
  }

  @override
  Future<void> updateTicket(Ticket ticket) async {
    try {
      _validateTicket(ticket);

      final existingTicket = await _localDataSource.getTicketById(ticket.id);
      if (existingTicket == null) {
        throw const NotFoundFailure();
      }

      final updatedTicket = ticket.copyWith(updatedAt: DateTime.now());
      await _localDataSource.saveTicket(updatedTicket);
      await _recordHistory(
        ticketId: ticket.id,
        message: _buildUpdateMessage(existingTicket, updatedTicket),
      );
    } on Failure {
      rethrow;
    } on CacheException catch (error) {
      throw CacheFailure(error.message ?? 'Unable to access local storage.');
    }
  }

  @override
  Future<void> deleteTicket(String id) async {
    try {
      if (id.trim().isEmpty) {
        throw const ValidationFailure('Ticket id is required.');
      }

      final existingTicket = await _localDataSource.getTicketById(id);
      if (existingTicket == null) {
        throw const NotFoundFailure();
      }

      await _historyDataSource.deleteEntriesForTicket(id);
      await _localDataSource.deleteTicket(id);
    } on Failure {
      rethrow;
    } on CacheException catch (error) {
      throw CacheFailure(error.message ?? 'Unable to access local storage.');
    }
  }

  @override
  Future<String> exportTicketsToJson() async {
    try {
      final tickets = await _localDataSource.getAllTickets();

      final payload = {
        'exportedAt': DateTime.now().toIso8601String(),
        'ticketCount': tickets.length,
        'tickets': tickets.map(TicketJsonMapper.toMap).toList(),
      };

      return const JsonEncoder.withIndent('  ').convert(payload);
    } on CacheException catch (error) {
      throw CacheFailure(error.message ?? 'Unable to access local storage.');
    }
  }

  @override
  Future<List<TicketHistoryEntry>> getTicketHistory(String ticketId) async {
    try {
      if (ticketId.trim().isEmpty) {
        throw const ValidationFailure('Ticket id is required.');
      }

      return _historyDataSource.getEntriesForTicket(ticketId);
    } on Failure {
      rethrow;
    } on CacheException catch (error) {
      throw CacheFailure(error.message ?? 'Unable to access local storage.');
    }
  }

  Future<void> _ensureCounterInitialized() async {
    final tickets = await _localDataSource.getAllTickets();
    await _settingsDataSource.initializeCounterFromTickets(tickets);
  }

  Future<void> _recordHistory({
    required String ticketId,
    required String message,
  }) async {
    await _historyDataSource.addEntry(
      TicketHistoryEntry(
        id: _uuid.v4(),
        ticketId: ticketId,
        message: message,
        timestamp: DateTime.now(),
      ),
    );
  }

  String _buildUpdateMessage(Ticket before, Ticket after) {
    final changes = <String>[];

    if (before.subject != after.subject) {
      changes.add('subject updated');
    }
    if (before.description != after.description) {
      changes.add('description updated');
    }
    if (before.priority != after.priority) {
      changes.add('priority changed to ${after.priority.label}');
    }
    if (before.status != after.status) {
      changes.add('status changed to ${after.status.label}');
    }

    if (changes.isEmpty) {
      return 'Ticket updated';
    }

    return 'Ticket updated: ${changes.join(', ')}';
  }

  void _validateTicket(Ticket ticket) {
    if (ticket.id.trim().isEmpty) {
      throw const ValidationFailure('Ticket id is required.');
    }

    if (ticket.ticketNumber.trim().isEmpty) {
      throw const ValidationFailure('Ticket number is required.');
    }

    if (ticket.subject.trim().isEmpty) {
      throw const ValidationFailure('Subject is required.');
    }

    if (ticket.description.trim().isEmpty) {
      throw const ValidationFailure('Description is required.');
    }
  }
}
