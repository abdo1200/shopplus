import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopplus/core/di/service_locator.dart';
import 'package:shopplus/features/wallet/presentation/wallet/bloc/wallet_bloc.dart';
import 'package:shopplus/features/wallet/presentation/wallet/bloc/wallet_event.dart';
import 'package:shopplus/features/wallet/presentation/wallet/widgets/wallet_view.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<WalletBloc>()..add(const WalletStarted()),
      child: const WalletView(),
    );
  }
}
