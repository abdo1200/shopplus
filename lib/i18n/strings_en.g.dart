///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import

part of 'strings.g.dart';

// Path: <root>
typedef TranslationsEn = Translations; // ignore: unused_element

class Translations with BaseTranslations<AppLocale, Translations> {
  /// Returns the current translations of the given [context].
  ///
  /// Usage:
  /// final t = Translations.of(context);
  static Translations of(BuildContext context) =>
      InheritedLocaleData.of<AppLocale, Translations>(context).translations;

  /// You can call this constructor and build your own translation instance of this locale.
  /// Constructing via the enum [AppLocale.build] is preferred.
  Translations({
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
             locale: AppLocale.en,
             overrides: overrides ?? {},
             cardinalResolver: cardinalResolver,
             ordinalResolver: ordinalResolver,
           ) {
    $meta.setFlatMapFunction(_flatMapFunction);
  }

  /// Metadata for the translations of <en>.
  @override
  final TranslationMetadata<AppLocale, Translations> $meta;

  /// Access flat map
  dynamic operator [](String key) => $meta.getTranslation(key);

  late final Translations _root = this; // ignore: unused_field

  Translations $copyWith({
    TranslationMetadata<AppLocale, Translations>? meta,
  }) => Translations(meta: meta ?? this.$meta);

  // Translations

  /// en: 'ShopPlus Wallet'
  String get appTitle => 'ShopPlus Wallet';

  /// en: 'Wallet'
  String get walletTitle => 'Wallet';

  /// en: 'Transfer points'
  String get transferPoints => 'Transfer points';

  /// en: 'Total Balance'
  String get totalBalance => 'Total Balance';

  /// en: 'pts'
  String get pointsUnit => 'pts';

  /// en: 'Pending'
  String get pendingPoints => 'Pending';

  /// en: 'Expiring'
  String get expiringPoints => 'Expiring';

  /// en: 'Merchant balances'
  String get merchantBalances => 'Merchant balances';

  /// en: 'Transactions'
  String get transactions => 'Transactions';

  /// en: 'All'
  String get filterAll => 'All';

  /// en: 'Earn'
  String get filterEarn => 'Earn';

  /// en: 'Redeem'
  String get filterRedeem => 'Redeem';

  /// en: 'Transfer'
  String get filterTransfer => 'Transfer';

  /// en: 'Purchase'
  String get filterPurchase => 'Purchase';

  /// en: 'Retry'
  String get retry => 'Retry';

  /// en: 'No transactions match this filter.'
  String get noTransactions => 'No transactions match this filter.';

  /// en: 'We could not load your wallet. Please try again.'
  String get walletLoadError =>
      'We could not load your wallet. Please try again.';

  /// en: 'Recipient email or phone'
  String get recipientLabel => 'Recipient email or phone';

  /// en: 'Points amount'
  String get pointsAmountLabel => 'Points amount';

  /// en: 'Note'
  String get noteLabel => 'Note';

  /// en: 'Optional'
  String get noteOptional => 'Optional';

  /// en: 'Available balance'
  String get availableBalance => 'Available balance';

  /// en: 'Send points'
  String get sendPoints => 'Send points';

  /// en: 'Enter a valid email or Egyptian phone number.'
  String get recipientInvalid =>
      'Enter a valid email or Egyptian phone number.';

  /// en: 'Transfer at least 100 points.'
  String get pointsMinimum => 'Transfer at least 100 points.';

  /// en: 'Enter whole points only.'
  String get pointsWholeNumber => 'Enter whole points only.';

  /// en: 'Points cannot exceed your available balance.'
  String get pointsExceedBalance =>
      'Points cannot exceed your available balance.';

  /// en: 'Note must be 150 characters or less.'
  String get noteTooLong => 'Note must be 150 characters or less.';

  /// en: 'Transfer complete'
  String get transferSuccessTitle => 'Transfer complete';

  /// en: 'You sent $points points. New balance: $balance points.'
  String transferSuccessMessage({
    required Object points,
    required Object balance,
  }) => 'You sent ${points} points. New balance: ${balance} points.';

  /// en: 'Done'
  String get done => 'Done';

  /// en: 'You do not have enough points.'
  String get insufficientBalance => 'You do not have enough points.';

  /// en: 'Recipient not found.'
  String get recipientNotFound => 'Recipient not found.';

  /// en: 'Something went wrong. Please try again.'
  String get unexpectedError => 'Something went wrong. Please try again.';

  /// en: 'Completed'
  String get completed => 'Completed';

  /// en: 'Pending'
  String get pending => 'Pending';

  /// en: 'Switch to Arabic'
  String get switchToArabic => 'Switch to Arabic';

  /// en: 'Switch to English'
  String get switchToEnglish => 'Switch to English';

  /// en: 'Switch to dark theme'
  String get switchToDarkTheme => 'Switch to dark theme';

  /// en: 'Switch to light theme'
  String get switchToLightTheme => 'Switch to light theme';

  /// en: 'AR'
  String get languageArabicShort => 'AR';

  /// en: 'EN'
  String get languageEnglishShort => 'EN';
}

/// The flat map containing all translations for locale <en>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on Translations {
  dynamic _flatMapFunction(String path) {
    return switch (path) {
      'appTitle' => 'ShopPlus Wallet',
      'walletTitle' => 'Wallet',
      'transferPoints' => 'Transfer points',
      'totalBalance' => 'Total Balance',
      'pointsUnit' => 'pts',
      'pendingPoints' => 'Pending',
      'expiringPoints' => 'Expiring',
      'merchantBalances' => 'Merchant balances',
      'transactions' => 'Transactions',
      'filterAll' => 'All',
      'filterEarn' => 'Earn',
      'filterRedeem' => 'Redeem',
      'filterTransfer' => 'Transfer',
      'filterPurchase' => 'Purchase',
      'retry' => 'Retry',
      'noTransactions' => 'No transactions match this filter.',
      'walletLoadError' => 'We could not load your wallet. Please try again.',
      'recipientLabel' => 'Recipient email or phone',
      'pointsAmountLabel' => 'Points amount',
      'noteLabel' => 'Note',
      'noteOptional' => 'Optional',
      'availableBalance' => 'Available balance',
      'sendPoints' => 'Send points',
      'recipientInvalid' => 'Enter a valid email or Egyptian phone number.',
      'pointsMinimum' => 'Transfer at least 100 points.',
      'pointsWholeNumber' => 'Enter whole points only.',
      'pointsExceedBalance' => 'Points cannot exceed your available balance.',
      'noteTooLong' => 'Note must be 150 characters or less.',
      'transferSuccessTitle' => 'Transfer complete',
      'transferSuccessMessage' =>
        ({required Object points, required Object balance}) =>
            'You sent ${points} points. New balance: ${balance} points.',
      'done' => 'Done',
      'insufficientBalance' => 'You do not have enough points.',
      'recipientNotFound' => 'Recipient not found.',
      'unexpectedError' => 'Something went wrong. Please try again.',
      'completed' => 'Completed',
      'pending' => 'Pending',
      'switchToArabic' => 'Switch to Arabic',
      'switchToEnglish' => 'Switch to English',
      'switchToDarkTheme' => 'Switch to dark theme',
      'switchToLightTheme' => 'Switch to light theme',
      'languageArabicShort' => 'AR',
      'languageEnglishShort' => 'EN',
      _ => null,
    };
  }
}
