import 'package:flutter/material.dart';
import 'package:shopplus/features/wallet/domain/entities/wallet_transaction_entity.dart';
import 'package:shopplus/features/wallet/presentation/wallet/bloc/wallet_state.dart';
import 'package:shopplus/features/wallet/presentation/wallet/widgets/merchant_balance_list.dart';
import 'package:shopplus/features/wallet/presentation/wallet/widgets/transactions_area.dart';
import 'package:shopplus/features/wallet/presentation/wallet/widgets/wallet_balance_card.dart';
import 'package:shopplus/features/wallet/presentation/wallet/widgets/wallet_filter_chips.dart';
import 'package:shopplus/features/wallet/presentation/wallet/widgets/wallet_page_header.dart';

class WideWalletLayout extends StatelessWidget {
  const WideWalletLayout({
    super.key,
    required this.state,
    required this.onFilterChanged,
    required this.onTransfer,
  });

  final WalletState state;
  final ValueChanged<WalletTransactionType?> onFilterChanged;
  final VoidCallback onTransfer;

  static const double _maxContentWidth = 1280;
  static const double _summaryWidth = 420;
  static const double _gap = 24;

  @override
  Widget build(BuildContext context) {
    final balance = state.balance;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: _maxContentWidth),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const WalletPageHeader(),
            const SizedBox(height: 22),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: _summaryWidth,
                    child: NotificationListener<ScrollNotification>(
                      onNotification: (_) => true,
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            if (balance != null) ...[
                              WalletBalanceCard(
                                balance: balance,
                                onTransfer: onTransfer,
                              ),
                              const SizedBox(height: 16),
                              MerchantBalanceList(
                                merchants: balance.balancesByMerchant,
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: _gap),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        WalletFilterChips(
                          selectedType: state.selectedType,
                          onChanged: onFilterChanged,
                        ),
                        const SizedBox(height: 12),
                        TransactionsArea(
                          transactions: state.transactions,
                          isLoading: state.isLoading,
                          isPaging: state.isPaging,
                          fillAvailableSpace: true,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
