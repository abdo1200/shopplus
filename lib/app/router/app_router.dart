import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:shopplus/features/wallet/presentation/transfer/transfer_points_screen.dart';
import 'package:shopplus/features/wallet/presentation/wallet/wallet_screen.dart';

class AppRouter {
  const AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: WalletRoute.path,
    routes: [
      GoRoute(
        path: WalletRoute.path,
        builder: (context, state) => const WalletScreen(),
      ),
      GoRoute(
        path: TransferPointsRoute.path,
        redirect: (BuildContext context, GoRouterState state) {
          if (state.extra is int) {
            return null;
          }

          return WalletRoute.path;
        },
        builder: (context, state) {
          final int availableBalance = state.extra! as int;
          return TransferPointsScreen(availableBalance: availableBalance);
        },
      ),
    ],
  );
}

class WalletRoute {
  const WalletRoute._();

  static const String path = '/wallet';
}

class TransferPointsRoute {
  const TransferPointsRoute._();

  static const String path = '/wallet/transfer';
}
