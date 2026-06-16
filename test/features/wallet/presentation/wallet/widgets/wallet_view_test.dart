import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shopplus/core/design_system/shopplus_theme.dart';
import 'package:shopplus/core/domain/storage/setting_preferences.dart';
import 'package:shopplus/core/localization/localization_cubit.dart';
import 'package:shopplus/core/theme/theme_cubit.dart';
import 'package:shopplus/features/wallet/domain/entities/merchant_balance_entity.dart';
import 'package:shopplus/features/wallet/domain/entities/paginated_transactions_entity.dart';
import 'package:shopplus/features/wallet/domain/entities/points_balance_entity.dart';
import 'package:shopplus/features/wallet/domain/entities/transfer_result_entity.dart';
import 'package:shopplus/features/wallet/domain/entities/wallet_transaction_entity.dart';
import 'package:shopplus/features/wallet/domain/params/get_transactions_params.dart';
import 'package:shopplus/features/wallet/domain/params/transfer_request_params.dart';
import 'package:shopplus/features/wallet/domain/repositories/wallet_repository.dart';
import 'package:shopplus/features/wallet/domain/usecases/get_wallet_balance_usecase.dart';
import 'package:shopplus/features/wallet/domain/usecases/get_wallet_transactions_usecase.dart';
import 'package:shopplus/features/wallet/presentation/wallet/bloc/wallet_bloc.dart';
import 'package:shopplus/features/wallet/presentation/wallet/bloc/wallet_event.dart';
import 'package:shopplus/features/wallet/presentation/wallet/bloc/wallet_state.dart';
import 'package:shopplus/features/wallet/presentation/wallet/widgets/wallet_view.dart';
import 'package:shopplus/i18n/strings.g.dart';

void main() {
  group('WalletView', () {
    testWidgets('should show a snackbar when refresh fails after data loads', (
      tester,
    ) async {
      final repository = _RefreshFailsWalletRepository();
      final bloc = WalletBloc(
        getBalance: GetWalletBalanceUseCase(repository),
        getTransactions: GetWalletTransactionsUseCase(repository),
      );
      addTearDown(bloc.close);

      await _pumpWalletView(tester, bloc);

      bloc.add(const WalletStarted());
      await tester.pump();
      await tester.pump();

      expect(bloc.state.status, WalletStatus.ready);
      expect(bloc.state.isLoading, isFalse);
      expect(find.byType(SnackBar), findsNothing);

      bloc.add(const WalletRefreshed());
      await tester.pump();
      await tester.pump();

      expect(bloc.state.loadErrorMessage, 'Refresh failed');
      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text(t.walletLoadError), findsOneWidget);
      expect(find.text(t.retry), findsOneWidget);
    });
  });
}

Future<void> _pumpWalletView(WidgetTester tester, WalletBloc bloc) async {
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
          BlocProvider<WalletBloc>.value(value: bloc),
        ],
        child: MaterialApp(
          theme: ShopPlusTheme.light(),
          home: const WalletView(),
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

final class _RefreshFailsWalletRepository implements WalletRepository {
  int _balanceRequestCount = 0;

  @override
  Future<PointsBalanceEntity> getBalance() async {
    _balanceRequestCount += 1;
    if (_balanceRequestCount > 1) {
      throw Exception('Refresh failed');
    }

    return _balance;
  }

  @override
  Future<PaginatedTransactionsEntity> getTransactions(
    GetTransactionsParams params,
  ) async {
    return _transactionPage;
  }

  @override
  Future<TransferResultEntity> transferPoints(TransferRequestParams params) {
    throw UnimplementedError();
  }
}

final PointsBalanceEntity _balance = PointsBalanceEntity(
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
);

final PaginatedTransactionsEntity _transactionPage =
    PaginatedTransactionsEntity(
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
      page: 1,
      totalItems: 1,
      hasNext: false,
    );
