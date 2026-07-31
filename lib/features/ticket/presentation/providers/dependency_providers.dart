import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/services/hive_service.dart';
import '../../data/datasources/ticket_local_datasource.dart';
import '../../data/datasources/ticket_local_datasource_impl.dart';
import '../../data/repositories/ticket_repository_impl.dart';
import '../../domain/repositories/ticket_repository.dart';

/// Provides the shared [HiveService] instance.
final hiveServiceProvider = Provider<HiveService>((ref) {
  return HiveService();
});

/// Provides the ticket local data source.
final ticketLocalDataSourceProvider = Provider<TicketLocalDataSource>((ref) {
  final hiveService = ref.watch(hiveServiceProvider);
  return TicketLocalDataSourceImpl(hiveService);
});

/// Provides the ticket repository.
final ticketRepositoryProvider = Provider<TicketRepository>((ref) {
  final localDataSource = ref.watch(ticketLocalDataSourceProvider);
  return TicketRepositoryImpl(localDataSource);
});
