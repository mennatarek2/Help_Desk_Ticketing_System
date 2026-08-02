import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

import '../../../../core/utils/failure_message.dart';
import 'dependency_providers.dart';

/// Result of exporting tickets to JSON.
sealed class ExportTicketsResult {
  const ExportTicketsResult();
}

class ExportTicketsSuccess extends ExportTicketsResult {
  const ExportTicketsSuccess(this.filePath);

  final String filePath;
}

class ExportTicketsFailure extends ExportTicketsResult {
  const ExportTicketsFailure(this.message);

  final String message;
}

/// Writes all tickets to a JSON file in the app documents directory.
class ExportTicketsController {
  ExportTicketsController(this._ref);

  final Ref _ref;

  Future<ExportTicketsResult> export() async {
    try {
      final repository = _ref.read(ticketRepositoryProvider);
      final json = await repository.exportTicketsToJson();
      final directory = await getApplicationDocumentsDirectory();
      final timestamp = DateTime.now().toIso8601String().replaceAll(':', '-');
      final file = File('${directory.path}/tickets_export_$timestamp.json');
      await file.writeAsString(json);

      return ExportTicketsSuccess(file.path);
    } catch (error) {
      return ExportTicketsFailure(
        resolveFailureMessage(
          error,
          fallback: 'Unable to export tickets. Please try again.',
        ),
      );
    }
  }
}

/// Provides [ExportTicketsController] for export actions.
final exportTicketsControllerProvider = Provider<ExportTicketsController>(
  (ref) => ExportTicketsController(ref),
);
