import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopplus/core/domain/storage/setting_preferences.dart';
import 'package:shopplus/i18n/strings.g.dart';

final class SharedPrefsSettingPreferences implements SettingPreferences {
  const SharedPrefsSettingPreferences(this._prefs);

  final SharedPreferences _prefs;

  static const _keyThemeMode = 'app_theme_mode';
  static const _keyLocale = 'app_locale';

  ThemeMode _deviceThemeMode() {
    final brightness =
        WidgetsBinding.instance.platformDispatcher.platformBrightness;
    return brightness == Brightness.dark ? ThemeMode.dark : ThemeMode.light;
  }

  @override
  Future<ThemeMode> loadThemeMode() async {
    final value = _prefs.getString(_keyThemeMode);
    return switch (value) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      'system' => _deviceThemeMode(),
      _ => _deviceThemeMode(),
    };
  }

  @override
  Future<void> saveThemeMode(ThemeMode mode) async {
    final value = switch (mode) {
      ThemeMode.light => 'light',
      ThemeMode.dark => 'dark',
      ThemeMode.system => 'system',
    };
    await _prefs.setString(_keyThemeMode, value);
  }

  @override
  Future<AppLocale> loadLocale() async {
    final tag = _prefs.getString(_keyLocale);
    if (tag == null) {
      final deviceLanguage =
          WidgetsBinding.instance.platformDispatcher.locale.languageCode;
      return AppLocale.values.firstWhere(
        (locale) => locale.languageCode == deviceLanguage,
        orElse: () => AppLocale.en,
      );
    }

    return AppLocale.values.firstWhere(
      (locale) => locale.languageTag == tag,
      orElse: () => AppLocale.en,
    );
  }

  @override
  Future<void> saveLocale(AppLocale locale) async {
    await _prefs.setString(_keyLocale, locale.languageTag);
  }
}
