import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shopplus/core/design_system/shopplus_theme.dart';
import 'package:shopplus/core/domain/storage/setting_preferences.dart';
import 'package:shopplus/core/localization/localization_cubit.dart';
import 'package:shopplus/core/theme/theme_cubit.dart';
import 'package:shopplus/features/wallet/domain/entities/merchant_balance_entity.dart';
import 'package:shopplus/features/wallet/domain/entities/points_balance_entity.dart';
import 'package:shopplus/features/wallet/domain/entities/wallet_transaction_entity.dart';
import 'package:shopplus/features/wallet/presentation/wallet/bloc/wallet_state.dart';
import 'package:shopplus/features/wallet/presentation/wallet/widgets/wallet_body.dart';
import 'package:shopplus/i18n/strings.g.dart';

void main() {
  group('WalletBody', () {
    testWidgets('should render wide layout without layout exceptions', (
      tester,
    ) async {
      await _pumpWalletBody(tester, size: const Size(1200, 900));

      await tester.pump();

      expect(tester.takeException(), isNull);
    });

    testWidgets('should render mobile layout without layout exceptions', (
      tester,
    ) async {
      await _pumpWalletBody(tester, size: const Size(390, 844));

      await tester.pump();

      expect(tester.takeException(), isNull);
    });

    testWidgets('should use a bounded transaction list on wide screens', (
      tester,
    ) async {
      await _pumpWalletBody(tester, size: const Size(1200, 900));

      expect(find.byType(ListView), findsOneWidget);
    });

    testWidgets('should use a bounded transaction list on mobile', (
      tester,
    ) async {
      await _pumpWalletBody(tester, size: const Size(390, 844));

      expect(find.byType(ListView), findsOneWidget);
    });
  });
}

Future<void> _pumpWalletBody(
  WidgetTester tester, {
  required Size size,
  WalletState? state,
}) async {
  final walletState = state ?? _readyState;

  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  await tester.pumpWidget(
    TranslationProvider(
      child: MultiBlocProvider(
        providers: [
          BlocProvider<ThemeCubit>(
            create: (_) => ThemeCubit(_TestSettingPreferences()),
          ),
          BlocProvider<LocalizationCubit>(
            create: (_) => LocalizationCubit(_TestSettingPreferences()),
          ),
        ],
        child: MaterialApp(
          theme: ShopPlusTheme.light(),
          home: Scaffold(
            body: WalletBody(
              state: walletState,
              onRetry: () {},
              onRefresh: () async {},
              onFilterChanged: (_) {},
              onLoadMore: () {},
              onTransfer: () {},
            ),
          ),
        ),
      ),
    ),
  );
}

final class _TestSettingPreferences implements SettingPreferences {
  @override
  Future<AppLocale> loadLocale() async => AppLocale.en;

  @override
  Future<ThemeMode> loadThemeMode() async => ThemeMode.light;

  @override
  Future<void> saveLocale(AppLocale locale) async {}

  @override
  Future<void> saveThemeMode(ThemeMode mode) async {}
}

final WalletState _readyState = WalletState(
  status: WalletStatus.ready,
  balance: PointsBalanceEntity(
    totalPoints: 15750,
    pendingPoints: 500,
    expiringPoints: 1200,
    expiringDate: DateTime.utc(2026, 3, 31),
    lastUpdated: DateTime.utc(2026, 2, 15),
    balancesByMerchant: const [
      MerchantBalanceEntity(
        merchantId: 'merchant_001',
        merchantName: 'TechMart',
        merchantLogo: 'https://example.com/techmart.png',
        points: 8500,
        tier: 'Gold',
      ),
    ],
  ),
  transactions: [
    WalletTransactionEntity(
      id: 'txn_001',
      type: WalletTransactionType.earn,
      points: 500,
      description: 'Purchase at TechMart',
      createdAt: DateTime.utc(2026, 2, 15, 14, 30),
      status: WalletTransactionStatus.completed,
      merchantName: 'TechMart',
    ),
  ],
  hasMore: false,
);
