import 'dart:collection';

import 'package:equatable/equatable.dart';

import '../../../domain/entities/points_balance_entity.dart';
import '../../../domain/entities/wallet_transaction_entity.dart';

enum WalletStatus { initial, ready }

class WalletState extends Equatable {
  WalletState({
    this.status = WalletStatus.initial,
    this.balance,
    List<WalletTransactionEntity> transactions = const [],
    this.selectedType,
    this.isLoading = false,
    this.isRefreshing = false,
    this.isPaging = false,
    this.hasMore = true,
    this.currentPage = 1,
    this.loadErrorMessage,
  }) : _transactions = List<WalletTransactionEntity>.unmodifiable(transactions);

  final WalletStatus status;
  final PointsBalanceEntity? balance;
  final List<WalletTransactionEntity> _transactions;
  final WalletTransactionType? selectedType;
  final bool isLoading;
  final bool isRefreshing;
  final bool isPaging;
  final bool hasMore;
  final int currentPage;
  final String? loadErrorMessage;

  UnmodifiableListView<WalletTransactionEntity> get transactions {
    return UnmodifiableListView<WalletTransactionEntity>(_transactions);
  }

  WalletState copyWith({
    WalletStatus? status,
    PointsBalanceEntity? balance,
    List<WalletTransactionEntity>? transactions,
    WalletTransactionType? selectedType,
    bool? isLoading,
    bool? isRefreshing,
    bool? isPaging,
    bool? hasMore,
    int? currentPage,
    String? loadErrorMessage,
    bool clearSelectedType = false,
    bool clearLoadError = false,
  }) {
    return WalletState(
      status: status ?? this.status,
      balance: balance ?? this.balance,
      transactions: transactions == null
          ? _transactions
          : List<WalletTransactionEntity>.of(transactions),
      selectedType: clearSelectedType
          ? null
          : (selectedType ?? this.selectedType),
      isLoading: isLoading ?? this.isLoading,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      isPaging: isPaging ?? this.isPaging,
      hasMore: hasMore ?? this.hasMore,
      currentPage: currentPage ?? this.currentPage,
      loadErrorMessage: clearLoadError
          ? null
          : (loadErrorMessage ?? this.loadErrorMessage),
    );
  }

  @override
  List<Object?> get props => [
    status,
    balance,
    _transactions,
    selectedType,
    isLoading,
    isRefreshing,
    isPaging,
    hasMore,
    currentPage,
    loadErrorMessage,
  ];
}
