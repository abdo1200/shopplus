import 'package:flutter/material.dart';
import 'package:shopplus/core/extensions/localizations_extension.dart';

class WalletEmptyView extends StatelessWidget {
  const WalletEmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Center(
        child: Text(context.l10n.noTransactions, textAlign: TextAlign.center),
      ),
    );
  }
}
