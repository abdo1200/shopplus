import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shopplus/features/wallet/domain/entities/merchant_balance_entity.dart';

class MerchantBalanceCard extends StatelessWidget {
  const MerchantBalanceCard({
    super.key,
    required this.merchant,
    required this.numberFormat,
  });

  final MerchantBalanceEntity merchant;
  final NumberFormat numberFormat;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: colorScheme.primary.withValues(alpha: 0.12),
          child: ClipOval(
            child: Image.network(
              merchant.merchantLogo,
              width: 40,
              height: 40,
              cacheWidth: 80,
              cacheHeight: 80,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => Text(
                merchant.merchantName.characters.first,
                style: TextStyle(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
        ),
        title: Text(merchant.merchantName),
        subtitle: Text(merchant.tier),
        trailing: Text(
          numberFormat.format(merchant.points),
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}
