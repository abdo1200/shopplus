import 'wallet_transaction_model.dart';

final class PaginatedTransactionsModel {
  const PaginatedTransactionsModel({
    required this.transactions,
    required this.page,
    required this.totalItems,
    required this.hasNext,
  });

  factory PaginatedTransactionsModel.fromJson(Map<String, dynamic> json) {
    final transactions = json['transactions'] as List<dynamic>;

    return PaginatedTransactionsModel(
      transactions: transactions
          .map(
            (transaction) => WalletTransactionModel.fromJson(
              transaction as Map<String, dynamic>,
            ),
          )
          .toList(growable: false),
      page: json['page'] as int,
      totalItems: json['totalItems'] as int,
      hasNext: json['hasNext'] as bool,
    );
  }

  final List<WalletTransactionModel> transactions;
  final int page;
  final int totalItems;
  final bool hasNext;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'transactions': transactions
          .map((transaction) => transaction.toJson())
          .toList(growable: false),
      'page': page,
      'totalItems': totalItems,
      'hasNext': hasNext,
    };
  }

  PaginatedTransactionsModel copyWith({
    List<WalletTransactionModel>? transactions,
    int? page,
    int? totalItems,
    bool? hasNext,
  }) {
    return PaginatedTransactionsModel(
      transactions: transactions ?? this.transactions,
      page: page ?? this.page,
      totalItems: totalItems ?? this.totalItems,
      hasNext: hasNext ?? this.hasNext,
    );
  }
}
