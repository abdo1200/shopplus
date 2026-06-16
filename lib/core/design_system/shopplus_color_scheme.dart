part of 'shopplus_theme.dart';

final class ShopPlusColorScheme extends ThemeExtension<ShopPlusColorScheme> {
  const ShopPlusColorScheme({
    required this.success,
    required this.onAccent,
    required this.onBrand,
    required this.onBrandMuted,
    required this.brandOverlay,
  });

  final Color success;
  final Color onAccent;
  final Color onBrand;
  final Color onBrandMuted;
  final Color brandOverlay;

  @override
  ShopPlusColorScheme copyWith({
    Color? success,
    Color? onAccent,
    Color? onBrand,
    Color? onBrandMuted,
    Color? brandOverlay,
  }) {
    return ShopPlusColorScheme(
      success: success ?? this.success,
      onAccent: onAccent ?? this.onAccent,
      onBrand: onBrand ?? this.onBrand,
      onBrandMuted: onBrandMuted ?? this.onBrandMuted,
      brandOverlay: brandOverlay ?? this.brandOverlay,
    );
  }

  @override
  ShopPlusColorScheme lerp(
    ThemeExtension<ShopPlusColorScheme>? other,
    double t,
  ) {
    if (other is! ShopPlusColorScheme) {
      return this;
    }

    return ShopPlusColorScheme(
      success: Color.lerp(success, other.success, t)!,
      onAccent: Color.lerp(onAccent, other.onAccent, t)!,
      onBrand: Color.lerp(onBrand, other.onBrand, t)!,
      onBrandMuted: Color.lerp(onBrandMuted, other.onBrandMuted, t)!,
      brandOverlay: Color.lerp(brandOverlay, other.brandOverlay, t)!,
    );
  }
}

extension ShopPlusColorSchemeExtension on ThemeData {
  ShopPlusColorScheme get shopPlusColorScheme {
    return extension<ShopPlusColorScheme>()!;
  }
}
