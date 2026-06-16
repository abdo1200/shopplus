import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shopplus/features/wallet/data/repositories/mock_wallet_repository.dart';
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

final class MockFailingWalletRepository extends Mock
    implements WalletRepository {}

void main() {
  group('WalletBloc', () {
    late WalletRepository repository;

    WalletBloc buildBloc() {
      return WalletBloc(
        getBalance: GetWalletBalanceUseCase(repository),
        getTransactions: GetWalletTransactionsUseCase(repository),
      );
    }

    setUp(() {
      repository = MockWalletRepository(delay: Duration.zero);
    });

    test('should start with initial state', () {
      final bloc = buildBloc();
      addTearDown(bloc.close);

      expect(bloc.state.status, WalletStatus.initial);
      expect(bloc.state.transactions, isEmpty);
      expect(bloc.state.isLoading, isFalse);
    });

    test(
      'should request balance and transactions concurrently on start',
      () async {
        final repository = _ConcurrentLoadWalletRepository();
        final bloc = WalletBloc(
          getBalance: GetWalletBalanceUseCase(repository),
          getTransactions: GetWalletTransactionsUseCase(repository),
        );
        addTearDown(bloc.close);
        addTearDown(repository.completeRequests);

        bloc.add(const WalletStarted());
        await bloc.stream.firstWhere((state) => state.isLoading);
        await Future<void>.delayed(Duration.zero);

        expect(repository.balanceRequested, isTrue);
        expect(repository.transactionsRequested, isTrue);

        repository.completeRequests();
        await bloc.stream.firstWhere(
          (state) => state.status == WalletStatus.ready && !state.isLoading,
        );
      },
    );

    blocTest<WalletBloc, WalletState>(
      'should emit loading then ready when wallet starts',
      build: buildBloc,
      act: (bloc) => bloc.add(const WalletStarted()),
      wait: Duration.zero,
      expect: () => [
        isA<WalletState>().having(
          (state) => state.isLoading,
          'isLoading',
          isTrue,
        ),
        isA<WalletState>()
            .having((state) => state.status, 'status', WalletStatus.ready)
            .having((state) => state.isLoading, 'isLoading', isFalse)
            .having((state) => state.balance?.totalPoints, 'totalPoints', 15750)
            .having(
              (state) => state.transactions,
              'transactions',
              hasLength(10),
            ),
      ],
    );

    blocTest<WalletBloc, WalletState>(
      'should filter transactions and restore all transactions',
      build: buildBloc,
      act: (bloc) async {
        bloc.add(const WalletStarted());
        await Future<void>.delayed(const Duration(milliseconds: 1));

        bloc.add(const WalletFilterChanged(WalletTransactionType.transferOut));
        await Future<void>.delayed(const Duration(milliseconds: 1));

        bloc.add(const WalletFilterChanged(null));
      },
      wait: const Duration(milliseconds: 1),
      expect: () => [
        isA<WalletState>().having(
          (state) => state.isLoading,
          'isLoading',
          isTrue,
        ),
        isA<WalletState>()
            .having((state) => state.status, 'status', WalletStatus.ready)
            .having(
              (state) => state.transactions,
              'transactions',
              hasLength(10),
            ),
        isA<WalletState>()
            .having(
              (state) => state.selectedType,
              'selectedType',
              WalletTransactionType.transferOut,
            )
            .having((state) => state.isLoading, 'isLoading', isTrue)
            .having((state) => state.transactions, 'transactions', isEmpty),
        isA<WalletState>()
            .having(
              (state) => state.selectedType,
              'selectedType',
              WalletTransactionType.transferOut,
            )
            .having((state) => state.transactions, 'transactions', isNotEmpty)
            .having(
              (state) => state.transactions.every(
                (transaction) =>
                    transaction.type == WalletTransactionType.transferOut,
              ),
              'all transfer out',
              isTrue,
            ),
        isA<WalletState>()
            .having((state) => state.selectedType, 'selectedType', isNull)
            .having((state) => state.isLoading, 'isLoading', isTrue)
            .having((state) => state.transactions, 'transactions', isEmpty),
        isA<WalletState>()
            .having((state) => state.selectedType, 'selectedType', isNull)
            .having((state) => state.isLoading, 'isLoading', isFalse)
            .having(
              (state) => state.transactions,
              'transactions',
              hasLength(10),
            ),
      ],
    );

    blocTest<WalletBloc, WalletState>(
      'should reload balance and transactions when wallet refreshes',
      build: buildBloc,
      act: (bloc) async {
        bloc.add(const WalletStarted());
        await bloc.stream.firstWhere(
          (state) => state.status == WalletStatus.ready && !state.isLoading,
        );

        await repository.transferPoints(
          const TransferRequestParams(
            recipient: 'friend@test.com',
            points: 500,
          ),
        );

        bloc.add(const WalletRefreshed());
      },
      wait: const Duration(milliseconds: 1),
      expect: () => [
        isA<WalletState>().having(
          (state) => state.isLoading,
          'isLoading',
          isTrue,
        ),
        isA<WalletState>()
            .having((state) => state.status, 'status', WalletStatus.ready)
            .having((state) => state.balance?.totalPoints, 'totalPoints', 15750)
            .having(
              (state) => state.transactions.first.id,
              'firstTransactionId',
              'txn_001',
            ),
        isA<WalletState>().having(
          (state) => state.isRefreshing,
          'isRefreshing',
          isTrue,
        ),
        isA<WalletState>()
            .having((state) => state.isRefreshing, 'isRefreshing', isFalse)
            .having((state) => state.balance?.totalPoints, 'totalPoints', 15250)
            .having(
              (state) => state.transactions.first.description,
              'firstTransactionDescription',
              'Transfer to friend@test.com',
            ),
      ],
    );

    blocTest<WalletBloc, WalletState>(
      'should emit load error when repository throws exception',
      setUp: () {
        repository = MockFailingWalletRepository();
        when(
          () => repository.getBalance(),
        ).thenThrow(Exception('Server is down'));
      },
      build: buildBloc,
      act: (bloc) => bloc.add(const WalletStarted()),
      wait: Duration.zero,
      expect: () => [
        isA<WalletState>().having(
          (state) => state.isLoading,
          'isLoading',
          isTrue,
        ),
        isA<WalletState>()
            .having((state) => state.status, 'status', WalletStatus.ready)
            .having((state) => state.isLoading, 'isLoading', isFalse)
            .having(
              (state) => state.loadErrorMessage,
              'loadErrorMessage',
              'Server is down',
            ),
      ],
    );
  });
}

final class _ConcurrentLoadWalletRepository implements WalletRepository {
  final Completer<void> _balanceCompleter = Completer<void>();
  final Completer<void> _transactionsCompleter = Completer<void>();

  bool balanceRequested = false;
  bool transactionsRequested = false;

  @override
  Future<PointsBalanceEntity> getBalance() async {
    balanceRequested = true;
    await _balanceCompleter.future;
    return _balance;
  }

  @override
  Future<PaginatedTransactionsEntity> getTransactions(
    GetTransactionsParams params,
  ) async {
    transactionsRequested = true;
    await _transactionsCompleter.future;
    return _transactionPage;
  }

  @override
  Future<TransferResultEntity> transferPoints(TransferRequestParams params) {
    throw UnimplementedError();
  }

  void completeRequests() {
    if (!_balanceCompleter.isCompleted) {
      _balanceCompleter.complete();
    }
    if (!_transactionsCompleter.isCompleted) {
      _transactionsCompleter.complete();
    }
  }
}

final PointsBalanceEntity _balance = PointsBalanceEntity(
  totalPoints: 1000,
  pendingPoints: 0,
  expiringPoints: 0,
  expiringDate: DateTime.utc(2026, 1),
  lastUpdated: DateTime.utc(2026, 1),
  balancesByMerchant: const [
    MerchantBalanceEntity(
      merchantId: 'merchant_001',
      merchantName: 'TechMart',
      merchantLogo: 'https://example.com/techmart.png',
      points: 1000,
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
          points: 100,
          description: 'Purchase at TechMart',
          createdAt: DateTime.utc(2026, 1),
          status: WalletTransactionStatus.completed,
        ),
      ],
      page: 1,
      totalItems: 1,
      hasNext: false,
    );
