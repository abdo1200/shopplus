import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shopplus/app/router/app_router.dart';
import 'package:shopplus/core/design_system/shopplus_theme.dart';
import 'package:shopplus/core/localization/localization_cubit.dart';
import 'package:shopplus/core/theme/theme_cubit.dart';
import 'package:shopplus/i18n/strings.g.dart';

class ShopPlusMaterialApp extends StatelessWidget {
  const ShopPlusMaterialApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocalizationCubit, AppLocale>(
      builder: (context, locale) {
        return BlocBuilder<ThemeCubit, ThemeMode>(
          builder: (context, themeMode) {
            return MaterialApp.router(
              title: t.appTitle,
              theme: ShopPlusTheme.light(),
              darkTheme: ShopPlusTheme.dark(),
              themeMode: themeMode,
              locale: locale.flutterLocale,
              routerConfig: AppRouter.router,
              debugShowCheckedModeBanner: false,
              localizationsDelegates: const [
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: AppLocaleUtils.supportedLocales,
            );
          },
        );
      },
    );
  }
}
