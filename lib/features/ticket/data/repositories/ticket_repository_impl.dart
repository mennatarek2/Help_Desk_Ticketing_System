import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/ticket.dart';
import '../../domain/entities/ticket_sort_order.dart';
import '../../domain/entities/ticket_status.dart';
import '../../domain/repositories/ticket_repository.dart';
import '../datasources/ticket_local_datasource.dart';

/// Concrete implementation of [TicketRepository].
class TicketRepositoryImpl implements TicketRepository {
  TicketRepositoryImpl(this._localDataSource);

  final TicketLocalDataSource _localDataSource;

  @override
  Future<void> createTicket(Ticket ticket) async {
    try {
      _validateTicket(ticket);

      final existingTicket = await _localDataSource.getTicketById(ticket.id);
      if (existingTicket != null) {
        throw const ValidationFailure('A ticket with this id already exists.');
      }

      await _localDataSource.saveTicket(ticket);
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

  @override
  Future<List<Ticket>> searchTickets(String query) async {
    final tickets = await getTickets();
    final normalizedQuery = query.trim().toLowerCase();

    if (normalizedQuery.isEmpty) {
      return tickets;
    }

    return tickets
        .where(
          (ticket) => ticket.subject.toLowerCase().contains(normalizedQuery),
        )
        .toList();
  }

  @override
  Future<List<Ticket>> filterTickets({TicketStatus? status}) async {
    final tickets = await getTickets();

    if (status == null) {
      return tickets;
    }

    return tickets.where((ticket) => ticket.status == status).toList();
  }

  @override
  Future<List<Ticket>> sortTickets(
    List<Ticket> tickets,
    TicketSortOrder sortOrder,
  ) async {
    final sortedTickets = List<Ticket>.from(tickets);

    sortedTickets.sort((first, second) {
      switch (sortOrder) {
        case TicketSortOrder.newestFirst:
          return second.createdAt.compareTo(first.createdAt);
        case TicketSortOrder.oldestFirst:
          return first.createdAt.compareTo(second.createdAt);
      }
    });

    return sortedTickets;
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
