library;

import 'package:flutter/material.dart';

part 'shopplus_color_scheme.dart';
part 'shopplus_colors.dart';

final class ShopPlusTheme {
  const ShopPlusTheme._();

  static ThemeData light() {
    final ColorScheme colorScheme = ColorScheme.fromSeed(
      brightness: Brightness.light,
      seedColor: _ShopPlusColors.primary,
      primary: _ShopPlusColors.primary,
      secondary: _ShopPlusColors.secondary,
      error: _ShopPlusColors.error,
      surface: _ShopPlusColors.surface,
      outlineVariant: _ShopPlusColors.divider,
    );

    return _build(
      colorScheme: colorScheme,
      scaffoldBackgroundColor: _ShopPlusColors.background,
      surfaceColor: _ShopPlusColors.surface,
      appBarForegroundColor: _ShopPlusColors.textPrimary,
      dividerColor: _ShopPlusColors.divider,
      appColorScheme: const ShopPlusColorScheme(
        success: _ShopPlusColors.success,
        onAccent: _ShopPlusColors.onAccent,
        onBrand: _ShopPlusColors.onBrand,
        onBrandMuted: _ShopPlusColors.onBrandMuted,
        brandOverlay: _ShopPlusColors.brandOverlay,
      ),
    );
  }

  static ThemeData dark() {
    final ColorScheme colorScheme = ColorScheme.fromSeed(
      brightness: Brightness.dark,
      seedColor: _ShopPlusColors.primary,
      primary: _ShopPlusColors.primary,
      secondary: _ShopPlusColors.secondary,
      error: _ShopPlusColors.error,
      surface: _ShopPlusColors.darkSurface,
      outlineVariant: _ShopPlusColors.darkDivider,
    );

    return _build(
      colorScheme: colorScheme,
      scaffoldBackgroundColor: _ShopPlusColors.darkBackground,
      surfaceColor: _ShopPlusColors.darkSurface,
      appBarForegroundColor: _ShopPlusColors.darkTextPrimary,
      dividerColor: _ShopPlusColors.darkDivider,
      appColorScheme: const ShopPlusColorScheme(
        success: _ShopPlusColors.success,
        onAccent: _ShopPlusColors.onAccent,
        onBrand: _ShopPlusColors.onBrand,
        onBrandMuted: _ShopPlusColors.onBrandMuted,
        brandOverlay: _ShopPlusColors.brandOverlay,
      ),
    );
  }

  static ThemeData _build({
    required ColorScheme colorScheme,
    required Color scaffoldBackgroundColor,
    required Color surfaceColor,
    required Color appBarForegroundColor,
    required Color dividerColor,
    required ShopPlusColorScheme appColorScheme,
  }) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: scaffoldBackgroundColor,
      dividerColor: dividerColor,
      extensions: <ThemeExtension<dynamic>>[appColorScheme],
      appBarTheme: AppBarTheme(
        centerTitle: false,
        elevation: 0,
        backgroundColor: scaffoldBackgroundColor,
        foregroundColor: appBarForegroundColor,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: dividerColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: dividerColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: colorScheme.primary, width: 1.4),
        ),
      ),
    );
  }
}
