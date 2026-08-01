import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'core/services/hive_service.dart';
import 'core/utils/failure_message.dart';
import 'features/ticket/presentation/providers/dependency_providers.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    final hiveService = HiveService();
    await hiveService.init();

    runApp(
      ProviderScope(
        overrides: [
          hiveServiceProvider.overrideWithValue(hiveService),
        ],
        child: const App(),
      ),
    );
  } catch (error, stackTrace) {
    debugPrint('Application startup failed: $error');
    debugPrintStack(stackTrace: stackTrace);

    runApp(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                resolveFailureMessage(
                  error,
                  fallback:
                      'Failed to initialize local storage. Please restart the app.',
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
