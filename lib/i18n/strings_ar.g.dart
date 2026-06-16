///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import

import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:slang/generated.dart';
import 'strings.g.dart';

// Path: <root>
class TranslationsAr extends Translations
    with BaseTranslations<AppLocale, Translations> {
  /// You can call this constructor and build your own translation instance of this locale.
  /// Constructing via the enum [AppLocale.build] is preferred.
  TranslationsAr({
    Map<String, Node>? overrides,
    PluralResolver? cardinalResolver,
    PluralResolver? ordinalResolver,
    TranslationMetadata<AppLocale, Translations>? meta,
  }) : assert(
         overrides == null,
         'Set "translation_overrides: true" in order to enable this feature.',
       ),
       $meta =
           meta ??
           TranslationMetadata(
             locale: AppLocale.ar,
             overrides: overrides ?? {},
             cardinalResolver: cardinalResolver,
             ordinalResolver: ordinalResolver,
           ),
       super(
         cardinalResolver: cardinalResolver,
         ordinalResolver: ordinalResolver,
       ) {
    super.$meta.setFlatMapFunction(
      $meta.getTranslation,
    ); // copy base translations to super.$meta
    $meta.setFlatMapFunction(_flatMapFunction);
  }

  /// Metadata for the translations of <ar>.
  @override
  final TranslationMetadata<AppLocale, Translations> $meta;

  /// Access flat map
  @override
  dynamic operator [](String key) =>
      $meta.getTranslation(key) ?? super.$meta.getTranslation(key);

  late final TranslationsAr _root = this; // ignore: unused_field

  @override
  TranslationsAr $copyWith({
    TranslationMetadata<AppLocale, Translations>? meta,
  }) => TranslationsAr(meta: meta ?? this.$meta);

  // Translations
  @override
  String get appTitle => 'محفظة شوب بلس';
  @override
  String get walletTitle => 'المحفظة';
  @override
  String get transferPoints => 'تحويل النقاط';
  @override
  String get totalBalance => 'إجمالي الرصيد';
  @override
  String get pointsUnit => 'نقطة';
  @override
  String get pendingPoints => 'قيد الانتظار';
  @override
  String get expiringPoints => 'تنتهي قريبا';
  @override
  String get merchantBalances => 'أرصدة المتاجر';
  @override
  String get transactions => 'المعاملات';
  @override
  String get filterAll => 'الكل';
  @override
  String get filterEarn => 'اكتساب';
  @override
  String get filterRedeem => 'استبدال';
  @override
  String get filterTransfer => 'تحويل';
  @override
  String get filterPurchase => 'شراء';
  @override
  String get retry => 'إعادة المحاولة';
  @override
  String get noTransactions => 'لا توجد معاملات تطابق هذا الفلتر.';
  @override
  String get walletLoadError => 'تعذر تحميل المحفظة. حاول مرة أخرى.';
  @override
  String get recipientLabel => 'البريد الإلكتروني أو رقم الهاتف';
  @override
  String get pointsAmountLabel => 'عدد النقاط';
  @override
  String get noteLabel => 'ملاحظة';
  @override
  String get noteOptional => 'اختياري';
  @override
  String get availableBalance => 'الرصيد المتاح';
  @override
  String get sendPoints => 'إرسال النقاط';
  @override
  String get recipientInvalid =>
      'أدخل بريدا إلكترونيا صحيحا أو رقم هاتف مصريا.';
  @override
  String get pointsMinimum => 'يجب تحويل 100 نقطة على الأقل.';
  @override
  String get pointsWholeNumber => 'أدخل نقاطا صحيحة فقط.';
  @override
  String get pointsExceedBalance => 'لا يمكن أن تتجاوز النقاط الرصيد المتاح.';
  @override
  String get noteTooLong => 'يجب ألا تتجاوز الملاحظة 150 حرفا.';
  @override
  String get transferSuccessTitle => 'تم التحويل';
  @override
  String transferSuccessMessage({
    required Object points,
    required Object balance,
  }) => 'أرسلت ${points} نقطة. الرصيد الجديد: ${balance} نقطة.';
  @override
  String get done => 'تم';
  @override
  String get insufficientBalance => 'ليس لديك نقاط كافية.';
  @override
  String get recipientNotFound => 'لم يتم العثور على المستلم.';
  @override
  String get unexpectedError => 'حدث خطأ. حاول مرة أخرى.';
  @override
  String get completed => 'مكتملة';
  @override
  String get pending => 'قيد الانتظار';
  @override
  String get switchToArabic => 'التبديل إلى العربية';
  @override
  String get switchToEnglish => 'التبديل إلى الإنجليزية';
  @override
  String get switchToDarkTheme => 'التبديل إلى الوضع الداكن';
  @override
  String get switchToLightTheme => 'التبديل إلى الوضع الفاتح';
  @override
  String get languageArabicShort => 'ع';
  @override
  String get languageEnglishShort => 'EN';
}

/// The flat map containing all translations for locale <ar>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on TranslationsAr {
  dynamic _flatMapFunction(String path) {
    return switch (path) {
      'appTitle' => 'محفظة شوب بلس',
      'walletTitle' => 'المحفظة',
      'transferPoints' => 'تحويل النقاط',
      'totalBalance' => 'إجمالي الرصيد',
      'pointsUnit' => 'نقطة',
      'pendingPoints' => 'قيد الانتظار',
      'expiringPoints' => 'تنتهي قريبا',
      'merchantBalances' => 'أرصدة المتاجر',
      'transactions' => 'المعاملات',
      'filterAll' => 'الكل',
      'filterEarn' => 'اكتساب',
      'filterRedeem' => 'استبدال',
      'filterTransfer' => 'تحويل',
      'filterPurchase' => 'شراء',
      'retry' => 'إعادة المحاولة',
      'noTransactions' => 'لا توجد معاملات تطابق هذا الفلتر.',
      'walletLoadError' => 'تعذر تحميل المحفظة. حاول مرة أخرى.',
      'recipientLabel' => 'البريد الإلكتروني أو رقم الهاتف',
      'pointsAmountLabel' => 'عدد النقاط',
      'noteLabel' => 'ملاحظة',
      'noteOptional' => 'اختياري',
      'availableBalance' => 'الرصيد المتاح',
      'sendPoints' => 'إرسال النقاط',
      'recipientInvalid' => 'أدخل بريدا إلكترونيا صحيحا أو رقم هاتف مصريا.',
      'pointsMinimum' => 'يجب تحويل 100 نقطة على الأقل.',
      'pointsWholeNumber' => 'أدخل نقاطا صحيحة فقط.',
      'pointsExceedBalance' => 'لا يمكن أن تتجاوز النقاط الرصيد المتاح.',
      'noteTooLong' => 'يجب ألا تتجاوز الملاحظة 150 حرفا.',
      'transferSuccessTitle' => 'تم التحويل',
      'transferSuccessMessage' =>
        ({required Object points, required Object balance}) =>
            'أرسلت ${points} نقطة. الرصيد الجديد: ${balance} نقطة.',
      'done' => 'تم',
      'insufficientBalance' => 'ليس لديك نقاط كافية.',
      'recipientNotFound' => 'لم يتم العثور على المستلم.',
      'unexpectedError' => 'حدث خطأ. حاول مرة أخرى.',
      'completed' => 'مكتملة',
      'pending' => 'قيد الانتظار',
      'switchToArabic' => 'التبديل إلى العربية',
      'switchToEnglish' => 'التبديل إلى الإنجليزية',
      'switchToDarkTheme' => 'التبديل إلى الوضع الداكن',
      'switchToLightTheme' => 'التبديل إلى الوضع الفاتح',
      'languageArabicShort' => 'ع',
      'languageEnglishShort' => 'EN',
      _ => null,
    };
  }
}
