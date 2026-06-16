import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shopplus/core/design_system/shopplus_theme.dart';
import 'package:shopplus/core/extensions/localizations_extension.dart';
import 'package:shopplus/features/wallet/domain/entities/wallet_transaction_entity.dart';

class TransactionListItem extends StatelessWidget {
  const TransactionListItem({
    super.key,
    required this.transaction,
    required this.dateFormat,
    required this.pointsFormat,
  });

  final WalletTransactionEntity transaction;
  final DateFormat dateFormat;
  final NumberFormat pointsFormat;

  @override
  Widget build(BuildContext context) {
    final points = pointsFormat.format(transaction.points.abs());
    final date = dateFormat.format(transaction.createdAt);
    final colorScheme = Theme.of(context).colorScheme;
    final appColors = Theme.of(context).shopPlusColorScheme;
    final color = transaction.isPositive
        ? appColors.success
        : colorScheme.error;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withValues(alpha: 0.12),
          foregroundColor: color,
          child: Icon(_icon(transaction.type), size: 20),
        ),
        title: Text(
          transaction.description,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(date, maxLines: 1, overflow: TextOverflow.ellipsis),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${transaction.isPositive ? '+' : '-'}$points',
              style: TextStyle(color: color, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 4),
            Text(
              _statusLabel(context),
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _icon(WalletTransactionType type) {
    return switch (type) {
      WalletTransactionType.earn => Icons.add,
      WalletTransactionType.redeem => Icons.redeem,
      WalletTransactionType.transferIn => Icons.south_west,
      WalletTransactionType.transferOut => Icons.north_east,
      WalletTransactionType.purchase => Icons.shopping_bag_outlined,
    };
  }

  String _statusLabel(BuildContext context) {
    return switch (transaction.status) {
      WalletTransactionStatus.completed => context.l10n.completed,
      WalletTransactionStatus.pending => context.l10n.pending,
    };
  }
}
