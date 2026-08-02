import 'package:flutter/material.dart';

import '../../data/datasources/ticket_settings_local_datasource.dart';

/// Theme mode helpers for settings persistence.
extension TicketSettingsThemeMode on TicketSettingsLocalDataSource {
  Future<ThemeMode> getThemeMode() async {
    final name = await getThemeModeName();
    return switch (name) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    final name = switch (mode) {
      ThemeMode.light => 'light',
      ThemeMode.dark => 'dark',
      ThemeMode.system => 'system',
    };
    await setThemeModeName(name);
  }
}
