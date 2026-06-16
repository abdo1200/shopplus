import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopplus/app/shopplus_material_app.dart';
import 'package:shopplus/core/di/service_locator.dart';
import 'package:shopplus/core/localization/localization_cubit.dart';
import 'package:shopplus/core/theme/theme_cubit.dart';
import 'package:shopplus/i18n/strings.g.dart';

class ShopPlusApp extends StatelessWidget {
  const ShopPlusApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeCubit = sl<ThemeCubit>();
    final localizationCubit = sl<LocalizationCubit>();

    return TranslationProvider(
      child: MultiBlocProvider(
        providers: [
          BlocProvider.value(value: themeCubit),
          BlocProvider.value(value: localizationCubit),
        ],
        child: const ShopPlusMaterialApp(),
      ),
    );
  }
}
