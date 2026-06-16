import 'package:flutter/material.dart';
import 'package:shopplus/core/extensions/localizations_extension.dart';
import 'package:shopplus/features/wallet/domain/entities/wallet_transaction_entity.dart';

class WalletFilterChips extends StatelessWidget {
  const WalletFilterChips({
    super.key,
    required this.selectedType,
    required this.onChanged,
  });

  final WalletTransactionType? selectedType;
  final ValueChanged<WalletTransactionType?> onChanged;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final filters = <WalletTransactionType?>[
      null,
      WalletTransactionType.earn,
      WalletTransactionType.redeem,
      WalletTransactionType.transferOut,
      WalletTransactionType.purchase,
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: filters
            .map(
              (type) => Padding(
                padding: const EdgeInsetsDirectional.only(end: 8),
                child: ChoiceChip(
                  label: Text(
                    _label(context, type),
                    maxLines: 1,
                    overflow: TextOverflow.visible,
                  ),
                  selected: selectedType == type,
                  showCheckmark: true,
                  labelStyle: TextStyle(
                    color: selectedType == type
                        ? colorScheme.onSecondaryContainer
                        : colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                  backgroundColor: colorScheme.surface,
                  selectedColor: colorScheme.secondaryContainer,
                  side: BorderSide(color: colorScheme.outlineVariant),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  visualDensity: VisualDensity.standard,
                  onSelected: (_) => onChanged(type),
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  String _label(BuildContext context, WalletTransactionType? type) {
    return switch (type) {
      null => context.l10n.filterAll,
      WalletTransactionType.earn => context.l10n.filterEarn,
      WalletTransactionType.redeem => context.l10n.filterRedeem,
      WalletTransactionType.transferIn ||
      WalletTransactionType.transferOut => context.l10n.filterTransfer,
      WalletTransactionType.purchase => context.l10n.filterPurchase,
    };
  }
}
