import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/paginated_transactions_entity.dart';
import '../../../domain/entities/points_balance_entity.dart';
import '../../../domain/entities/wallet_transaction_entity.dart';
import '../../../domain/params/get_transactions_params.dart';
import '../../../domain/usecases/get_wallet_balance_usecase.dart';
import '../../../domain/usecases/get_wallet_transactions_usecase.dart';
import 'wallet_event.dart';
import 'wallet_state.dart';

class WalletBloc extends Bloc<WalletEvent, WalletState> {
  WalletBloc({
    required GetWalletBalanceUseCase getBalance,
    required GetWalletTransactionsUseCase getTransactions,
  }) : _getBalance = getBalance,
       _getTransactions = getTransactions,
       super(WalletState()) {
    on<WalletStarted>(_onStarted);
    on<WalletRefreshed>(_onRefreshed);
    on<WalletFilterChanged>(_onFilterChanged);
    on<WalletNextPageRequested>(_onNextPageRequested);
  }

  static const int _pageLimit = 10;

  final GetWalletBalanceUseCase _getBalance;
  final GetWalletTransactionsUseCase _getTransactions;
  int _loadGeneration = 0;

  Future<void> _onStarted(
    WalletStarted event,
    Emitter<WalletState> emit,
  ) async {
    if (state.isLoading) return;

    final generation = ++_loadGeneration;
    emit(
      state.copyWith(
        isLoading: true,
        isRefreshing: false,
        isPaging: false,
        currentPage: 1,
        hasMore: true,
        clearLoadError: true,
      ),
    );
    await _loadFirstPage(
      emit,
      type: state.selectedType,
      generation: generation,
    );
  }

  Future<void> _onRefreshed(
    WalletRefreshed event,
    Emitter<WalletState> emit,
  ) async {
    if (state.isLoading || state.isRefreshing) return;

    final generation = ++_loadGeneration;
    emit(
      state.copyWith(
        isRefreshing: true,
        isPaging: false,
        currentPage: 1,
        hasMore: true,
        clearLoadError: true,
      ),
    );
    await _loadFirstPage(
      emit,
      type: state.selectedType,
      generation: generation,
    );
  }

  Future<void> _onFilterChanged(
    WalletFilterChanged event,
    Emitter<WalletState> emit,
  ) async {
    if (state.isLoading || state.isRefreshing) return;
    if (event.type == state.selectedType && state.loadErrorMessage == null) {
      return;
    }

    final generation = ++_loadGeneration;
    emit(
      state.copyWith(
        selectedType: event.type,
        transactions: const [],
        isLoading: true,
        isRefreshing: false,
        isPaging: false,
        currentPage: 1,
        hasMore: true,
        clearSelectedType: event.type == null,
        clearLoadError: true,
      ),
    );
    await _loadTransactionPage(
      emit,
      page: 1,
      type: event.type,
      replaceTransactions: true,
      generation: generation,
    );
  }

  Future<void> _onNextPageRequested(
    WalletNextPageRequested event,
    Emitter<WalletState> emit,
  ) async {
    if (state.isLoading ||
        state.isRefreshing ||
        state.isPaging ||
        !state.hasMore) {
      return;
    }

    final generation = _loadGeneration;
    emit(state.copyWith(isPaging: true, clearLoadError: true));
    await _loadTransactionPage(
      emit,
      page: state.currentPage,
      type: state.selectedType,
      replaceTransactions: false,
      generation: generation,
    );
  }

  Future<void> _loadFirstPage(
    Emitter<WalletState> emit, {
    required WalletTransactionType? type,
    required int generation,
  }) async {
    try {
      final results = await Future.wait<Object>([
        _getBalance(),
        _getTransactions(
          GetTransactionsParams(page: 1, limit: _pageLimit, type: type),
        ),
      ]);
      final balance = results[0] as PointsBalanceEntity;
      final page = results[1] as PaginatedTransactionsEntity;
      if (generation != _loadGeneration) return;

      emit(
        state.copyWith(
          status: WalletStatus.ready,
          balance: balance,
          transactions: page.transactions.toList(growable: false),
          currentPage: page.page + 1,
          hasMore: page.hasNext,
          isLoading: false,
          isRefreshing: false,
          isPaging: false,
          clearLoadError: true,
        ),
      );
    } catch (error) {
      if (generation != _loadGeneration) return;
      _emitLoadError(emit, error);
    }
  }

  Future<void> _loadTransactionPage(
    Emitter<WalletState> emit, {
    required int page,
    required WalletTransactionType? type,
    required bool replaceTransactions,
    required int generation,
  }) async {
    try {
      final result = await _getTransactions(
        GetTransactionsParams(page: page, limit: _pageLimit, type: type),
      );
      if (generation != _loadGeneration) return;

      final transactions = replaceTransactions
          ? result.transactions.toList(growable: false)
          : [...state.transactions, ...result.transactions];

      emit(
        state.copyWith(
          status: WalletStatus.ready,
          transactions: transactions,
          currentPage: result.page + 1,
          hasMore: result.hasNext,
          isLoading: false,
          isRefreshing: false,
          isPaging: false,
          clearLoadError: true,
        ),
      );
    } catch (error) {
      if (generation != _loadGeneration) return;
      _emitLoadError(emit, error);
    }
  }

  void _emitLoadError(Emitter<WalletState> emit, Object error) {
    emit(
      state.copyWith(
        status: WalletStatus.ready,
        isLoading: false,
        isRefreshing: false,
        isPaging: false,
        loadErrorMessage: _errorMessage(error),
      ),
    );
  }

  String _errorMessage(Object error) {
    return error.toString().replaceFirst('Exception: ', '').trim();
  }
}
