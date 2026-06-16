import 'package:flutter/material.dart';
import 'package:shopplus/core/extensions/localizations_extension.dart';
import 'package:shopplus/features/wallet/presentation/wallet/widgets/wallet_app_bar_actions.dart';

class WalletPageHeader extends StatelessWidget {
  const WalletPageHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            context.l10n.walletTitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(
              context,
            ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
        ),
        const WalletAppBarActions(),
      ],
    );
  }
}
