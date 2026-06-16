import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shopplus/core/design_system/shopplus_theme.dart';
import 'package:shopplus/core/extensions/localizations_extension.dart';
import 'package:shopplus/features/wallet/domain/entities/points_balance_entity.dart';
import 'package:shopplus/features/wallet/presentation/wallet/widgets/metric_chip.dart';

class WalletBalanceCard extends StatelessWidget {
  const WalletBalanceCard({
    super.key,
    required this.balance,
    required this.onTransfer,
  });

  final PointsBalanceEntity balance;
  final VoidCallback onTransfer;

  @override
  Widget build(BuildContext context) {
    final numberFormat = NumberFormat.decimalPattern(
      Localizations.localeOf(context).toLanguageTag(),
    );
    final colorScheme = Theme.of(context).colorScheme;
    final appColors = Theme.of(context).shopPlusColorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.primary,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${numberFormat.format(balance.totalPoints)} '
              '${context.l10n.pointsUnit}',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: appColors.onBrand,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              context.l10n.totalBalance,
              style: TextStyle(color: appColors.onBrandMuted),
            ),
            const SizedBox(height: 18),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                MetricChip(
                  label: context.l10n.pendingPoints,
                  value: numberFormat.format(balance.pendingPoints),
                ),
                MetricChip(
                  label: context.l10n.expiringPoints,
                  value: numberFormat.format(balance.expiringPoints),
                ),
              ],
            ),
            const SizedBox(height: 18),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: colorScheme.secondary,
                foregroundColor: appColors.onAccent,
              ),
              onPressed: onTransfer,
              child: Text(context.l10n.transferPoints),
            ),
          ],
        ),
      ),
    );
  }
}
