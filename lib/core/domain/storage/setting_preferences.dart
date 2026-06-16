import 'package:flutter/material.dart';
import 'package:shopplus/i18n/strings.g.dart';

abstract interface class SettingPreferences {
  Future<ThemeMode> loadThemeMode();

  Future<void> saveThemeMode(ThemeMode mode);

  Future<AppLocale> loadLocale();

  Future<void> saveLocale(AppLocale locale);
}
