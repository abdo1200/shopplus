import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopplus/core/extensions/localizations_extension.dart';
import 'package:shopplus/core/localization/localization_cubit.dart';
import 'package:shopplus/core/theme/theme_cubit.dart';
import 'package:shopplus/i18n/strings.g.dart';

class WalletAppBarActions extends StatelessWidget {
  const WalletAppBarActions({super.key});

  @override
  Widget build(BuildContext context) {
    final currentLocale = context.watch<LocalizationCubit>().state;
    final targetLocale = currentLocale == AppLocale.en
        ? AppLocale.ar
        : AppLocale.en;
    final languageLabel = targetLocale == AppLocale.ar
        ? context.l10n.languageArabicShort
        : context.l10n.languageEnglishShort;
    final languageTooltip = targetLocale == AppLocale.ar
        ? context.l10n.switchToArabic
        : context.l10n.switchToEnglish;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Tooltip(
          message: languageTooltip,
          child: TextButton.icon(
            onPressed: () async {
              await context.read<LocalizationCubit>().setLocale(targetLocale);
            },
            icon: const Icon(Icons.language, size: 18),
            label: Text(languageLabel),
          ),
        ),
        BlocBuilder<ThemeCubit, ThemeMode>(
          builder: (context, state) {
            final isDarkMode = state == ThemeMode.dark;
            return IconButton(
              tooltip: isDarkMode
                  ? context.l10n.switchToLightTheme
                  : context.l10n.switchToDarkTheme,
              onPressed: () {
                context.read<ThemeCubit>().setTheme(
                  isDarkMode ? ThemeMode.light : ThemeMode.dark,
                );
              },
              icon: Icon(
                isDarkMode
                    ? Icons.light_mode_outlined
                    : Icons.dark_mode_outlined,
              ),
            );
          },
        ),
        const SizedBox(width: 8),
      ],
    );
  }
}
