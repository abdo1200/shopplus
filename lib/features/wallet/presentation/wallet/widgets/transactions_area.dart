import 'package:flutter/material.dart';
import 'package:shopplus/features/wallet/domain/entities/wallet_transaction_entity.dart';
import 'package:shopplus/features/wallet/presentation/wallet/widgets/transaction_list.dart';
import 'package:shopplus/features/wallet/presentation/wallet/widgets/wallet_empty_view.dart';

class TransactionsArea extends StatelessWidget {
  const TransactionsArea({
    super.key,
    required this.transactions,
    required this.isLoading,
    required this.isPaging,
    this.fillAvailableSpace = true,
  });

  final List<WalletTransactionEntity> transactions;
  final bool isLoading;
  final bool isPaging;
  final bool fillAvailableSpace;

  @override
  Widget build(BuildContext context) {
    final child = _buildContent();

    if (!fillAvailableSpace) {
      return child;
    }

    return Expanded(child: child);
  }

  Widget _buildContent() {
    if (transactions.isEmpty && isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (transactions.isEmpty) {
      return const WalletEmptyView();
    }

    return TransactionList(transactions: transactions, isPaging: isPaging);
  }
}
