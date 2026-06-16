import 'package:flutter/material.dart';
import 'package:shopplus/features/wallet/domain/entities/wallet_transaction_entity.dart';
import 'package:shopplus/features/wallet/presentation/wallet/bloc/wallet_state.dart';
import 'package:shopplus/features/wallet/presentation/wallet/widgets/merchant_balance_list.dart';
import 'package:shopplus/features/wallet/presentation/wallet/widgets/transactions_area.dart';
import 'package:shopplus/features/wallet/presentation/wallet/widgets/wallet_balance_card.dart';
import 'package:shopplus/features/wallet/presentation/wallet/widgets/wallet_filter_chips.dart';
import 'package:shopplus/features/wallet/presentation/wallet/widgets/wallet_page_header.dart';

class MobileWalletLayout extends StatelessWidget {
  const MobileWalletLayout({
    super.key,
    required this.state,
    required this.onFilterChanged,
    required this.onTransfer,
  });

  final WalletState state;
  final ValueChanged<WalletTransactionType?> onFilterChanged;
  final VoidCallback onTransfer;

  @override
  Widget build(BuildContext context) {
    final balance = state.balance;

    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(16, 10, 16, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const WalletPageHeader(),
          const SizedBox(height: 18),
          if (balance != null) ...[
            WalletBalanceCard(balance: balance, onTransfer: onTransfer),
            const SizedBox(height: 16),
            MerchantBalanceList(
              merchants: balance.balancesByMerchant,
              usePager: true,
            ),
          ],
          WalletFilterChips(
            selectedType: state.selectedType,
            onChanged: onFilterChanged,
          ),
          const SizedBox(height: 10),
          TransactionsArea(
            transactions: state.transactions,
            isLoading: state.isLoading,
            isPaging: state.isPaging,
          ),
        ],
      ),
    );
  }
}
