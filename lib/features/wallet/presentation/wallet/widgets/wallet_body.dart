import 'package:flutter/material.dart';
import 'package:shopplus/core/extensions/localizations_extension.dart';
import 'package:shopplus/features/wallet/domain/entities/wallet_transaction_entity.dart';
import 'package:shopplus/features/wallet/presentation/wallet/bloc/wallet_state.dart';
import 'package:shopplus/features/wallet/presentation/wallet/widgets/mobile_wallet_layout.dart';
import 'package:shopplus/features/wallet/presentation/wallet/widgets/wallet_error_view.dart';
import 'package:shopplus/features/wallet/presentation/wallet/widgets/wallet_refresh_overlay.dart';
import 'package:shopplus/features/wallet/presentation/wallet/widgets/wide_wallet_layout.dart';

class WalletBody extends StatelessWidget {
  const WalletBody({
    super.key,
    required this.state,
    required this.onRetry,
    required this.onRefresh,
    required this.onFilterChanged,
    required this.onLoadMore,
    required this.onTransfer,
  });

  final WalletState state;
  final VoidCallback onRetry;
  final Future<void> Function() onRefresh;
  final ValueChanged<WalletTransactionType?> onFilterChanged;
  final VoidCallback onLoadMore;
  final VoidCallback onTransfer;

  static const double _wideBreakpoint = 960;

  @override
  Widget build(BuildContext context) {
    if (state.isLoading && state.balance == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.loadErrorMessage != null && state.balance == null) {
      return WalletErrorView(
        message: context.l10n.walletLoadError,
        onRetry: onRetry,
      );
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        SafeArea(
          child: RefreshIndicator(
            onRefresh: onRefresh,
            child: NotificationListener<ScrollNotification>(
              onNotification: (notification) {
                if (_shouldLoadMore(notification, state)) {
                  onLoadMore();
                }
                return false;
              },
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth >= _wideBreakpoint;

                  if (isWide) {
                    return Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                        24,
                        18,
                        24,
                        28,
                      ),
                      child: WideWalletLayout(
                        state: state,
                        onFilterChanged: onFilterChanged,
                        onTransfer: onTransfer,
                      ),
                    );
                  }

                  return MobileWalletLayout(
                    state: state,
                    onFilterChanged: onFilterChanged,
                    onTransfer: onTransfer,
                  );
                },
              ),
            ),
          ),
        ),
        if (state.isRefreshing) const WalletRefreshOverlay(),
      ],
    );
  }
}

bool _shouldLoadMore(ScrollNotification notification, WalletState state) {
  if (!state.hasMore ||
      state.isLoading ||
      state.isRefreshing ||
      state.isPaging) {
    return false;
  }

  final metrics = notification.metrics;
  const edgeTolerance = 24.0;
  return metrics.axis == Axis.vertical &&
      metrics.maxScrollExtent > 0 &&
      metrics.pixels >= metrics.maxScrollExtent - edgeTolerance;
}
