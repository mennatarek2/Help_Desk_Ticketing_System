import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/utils/ticket_number_generator.dart';
import '../../domain/entities/ticket.dart';
import '../../domain/repositories/ticket_repository.dart';
import '../datasources/ticket_local_datasource.dart';
import '../datasources/ticket_settings_local_datasource.dart';

/// Concrete implementation of [TicketRepository].
class TicketRepositoryImpl implements TicketRepository {
  TicketRepositoryImpl(
    this._localDataSource,
    this._settingsDataSource,
  );

  final TicketLocalDataSource _localDataSource;
  final TicketSettingsLocalDataSource _settingsDataSource;

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

      await _localDataSource.deleteTicket(id);
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
