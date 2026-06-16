import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shopplus/app/router/app_router.dart';
import 'package:shopplus/core/extensions/localizations_extension.dart';
import 'package:shopplus/features/wallet/presentation/wallet/bloc/wallet_bloc.dart';
import 'package:shopplus/features/wallet/presentation/wallet/bloc/wallet_event.dart';
import 'package:shopplus/features/wallet/presentation/wallet/bloc/wallet_state.dart';
import 'package:shopplus/features/wallet/presentation/wallet/widgets/wallet_body.dart';

class WalletView extends StatelessWidget {
  const WalletView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<WalletBloc, WalletState>(
        listenWhen: (previous, current) {
          return current.balance != null &&
              current.loadErrorMessage != null &&
              previous.loadErrorMessage != current.loadErrorMessage;
        },
        listener: (context, state) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(context.l10n.walletLoadError),
                action: SnackBarAction(
                  label: context.l10n.retry,
                  onPressed: () {
                    context.read<WalletBloc>().add(const WalletRefreshed());
                  },
                ),
              ),
            );
        },
        buildWhen: (previous, current) => previous != current,
        builder: (context, state) {
          return WalletBody(
            state: state,
            onRetry: () =>
                context.read<WalletBloc>().add(const WalletStarted()),
            onRefresh: () async {
              context.read<WalletBloc>().add(const WalletRefreshed());
            },
            onFilterChanged: (type) =>
                context.read<WalletBloc>().add(WalletFilterChanged(type)),
            onLoadMore: () =>
                context.read<WalletBloc>().add(const WalletNextPageRequested()),
            onTransfer: () async {
              final balance = state.balance?.totalPoints ?? 0;
              final transferResult = await context.push<int>(
                TransferPointsRoute.path,
                extra: balance,
              );
              if (transferResult != null && context.mounted) {
                context.read<WalletBloc>().add(const WalletRefreshed());
              }
            },
          );
        },
      ),
    );
  }
}
