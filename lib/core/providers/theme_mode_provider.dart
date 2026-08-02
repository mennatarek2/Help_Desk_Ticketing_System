import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/ticket/data/datasources/ticket_settings_theme_mode.dart';
import '../../features/ticket/presentation/providers/dependency_providers.dart';

/// Loads and persists the application theme mode.
class ThemeModeNotifier extends AsyncNotifier<ThemeMode> {
  @override
  Future<ThemeMode> build() async {
    final settings = ref.read(ticketSettingsLocalDataSourceProvider);
    return settings.getThemeMode();
  }

  Future<void> toggle() async {
    final current = state.value ?? ThemeMode.system;
    final next = switch (current) {
      ThemeMode.light => ThemeMode.dark,
      ThemeMode.dark => ThemeMode.light,
      ThemeMode.system => ThemeMode.dark,
    };

    await _save(next);
  }

  Future<void> _save(ThemeMode mode) async {
    final settings = ref.read(ticketSettingsLocalDataSourceProvider);
    await settings.setThemeMode(mode);
    state = AsyncData(mode);
  }
}

/// Provides the active [ThemeMode] for [MaterialApp].
final themeModeProvider =
    AsyncNotifierProvider<ThemeModeNotifier, ThemeMode>(
  ThemeModeNotifier.new,
);
