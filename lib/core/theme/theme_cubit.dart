import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopplus/core/domain/storage/setting_preferences.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit(this._preferences) : super(ThemeMode.system) {
    _loadInitial();
  }

  final SettingPreferences _preferences;

  Future<void> _loadInitial() async {
    final mode = await _preferences.loadThemeMode();
    emit(mode);
  }

  Future<void> setTheme(ThemeMode mode) async {
    emit(mode);
    await _preferences.saveThemeMode(mode);
  }
}
