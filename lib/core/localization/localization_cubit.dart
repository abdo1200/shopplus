import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopplus/core/domain/storage/setting_preferences.dart';
import 'package:shopplus/i18n/strings.g.dart';

class LocalizationCubit extends Cubit<AppLocale> {
  LocalizationCubit(this._preferences) : super(LocaleSettings.currentLocale) {
    _loadInitial();
  }

  final SettingPreferences _preferences;

  Future<void> _loadInitial() async {
    final locale = await _preferences.loadLocale();
    await LocaleSettings.setLocale(locale);
    emit(locale);
  }

  Future<void> setLocale(AppLocale locale) async {
    await LocaleSettings.setLocale(locale);
    emit(locale);
    await _preferences.saveLocale(locale);
  }
}
