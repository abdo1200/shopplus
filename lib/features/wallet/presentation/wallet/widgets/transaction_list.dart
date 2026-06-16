import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shopplus/features/wallet/domain/entities/wallet_transaction_entity.dart';
import 'package:shopplus/features/wallet/presentation/wallet/widgets/transaction_list_item.dart';

class TransactionList extends StatelessWidget {
  const TransactionList({
    super.key,
    required this.transactions,
    required this.isPaging,
  });

  final List<WalletTransactionEntity> transactions;
  final bool isPaging;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).toLanguageTag();
    final dateFormat = DateFormat.yMMMd(locale).add_jm();
    final pointsFormat = NumberFormat.decimalPattern(locale);
    final itemCount = transactions.length + (isPaging ? 1 : 0);

    return ListView.separated(
      itemCount: itemCount,
      separatorBuilder: (context, index) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        if (index >= transactions.length) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        return TransactionListItem(
          transaction: transactions[index],
          dateFormat: dateFormat,
          pointsFormat: pointsFormat,
        );
      },
    );
  }
}
