import 'dart:collection';

import 'package:equatable/equatable.dart';

import 'wallet_transaction_entity.dart';

final class PaginatedTransactionsEntity extends Equatable {
  const PaginatedTransactionsEntity({
    required List<WalletTransactionEntity> transactions,
    required this.page,
    required this.totalItems,
    required this.hasNext,
  }) : _transactions = transactions;

  final List<WalletTransactionEntity> _transactions;
  final int page;
  final int totalItems;
  final bool hasNext;

  UnmodifiableListView<WalletTransactionEntity> get transactions {
    return UnmodifiableListView<WalletTransactionEntity>(_transactions);
  }

  PaginatedTransactionsEntity copyWith({
    List<WalletTransactionEntity>? transactions,
    int? page,
    int? totalItems,
    bool? hasNext,
  }) {
    return PaginatedTransactionsEntity(
      transactions: transactions ?? _transactions,
      page: page ?? this.page,
      totalItems: totalItems ?? this.totalItems,
      hasNext: hasNext ?? this.hasNext,
    );
  }

  @override
  List<Object?> get props => [_transactions, page, totalItems, hasNext];
}
