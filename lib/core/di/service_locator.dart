import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopplus/core/data/storage/settings_preferences.dart';
import 'package:shopplus/core/domain/storage/setting_preferences.dart';
import 'package:shopplus/core/localization/localization_cubit.dart';
import 'package:shopplus/core/network/network_config.dart';
import 'package:shopplus/core/theme/theme_cubit.dart';
import 'package:shopplus/features/wallet/di/wallet_injection.dart';

final GetIt sl = GetIt.instance;

Future<void> configureDependencies() async {
  await _registerCoreDependencies();
  registerWalletDependencies();
}

Future<void> resetDependenciesForTests() async {
  await sl.reset();
  await configureDependencies();
}

Future<void> _registerCoreDependencies() async {
  if (!sl.isRegistered<NetworkConfig>()) {
    sl.registerLazySingleton<NetworkConfig>(NetworkConfig.shopPlus);
  }

  if (!sl.isRegistered<SharedPreferences>()) {
    final preferences = await SharedPreferences.getInstance();
    sl.registerLazySingleton<SharedPreferences>(() => preferences);
  }

  if (!sl.isRegistered<SettingPreferences>()) {
    sl.registerLazySingleton<SettingPreferences>(
      () => SharedPrefsSettingPreferences(sl()),
    );
  }

  if (!sl.isRegistered<ThemeCubit>()) {
    sl.registerLazySingleton<ThemeCubit>(() => ThemeCubit(sl()));
  }

  if (!sl.isRegistered<LocalizationCubit>()) {
    sl.registerLazySingleton<LocalizationCubit>(() => LocalizationCubit(sl()));
  }
}
