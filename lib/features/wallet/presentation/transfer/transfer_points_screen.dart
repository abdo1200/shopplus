import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopplus/core/di/service_locator.dart';
import 'package:shopplus/features/wallet/presentation/transfer/bloc/transfer_points_bloc.dart';
import 'package:shopplus/features/wallet/presentation/transfer/widgets/transfer_points_effects_listener.dart';
import 'package:shopplus/features/wallet/presentation/transfer/widgets/transfer_points_view.dart';

class TransferPointsScreen extends StatelessWidget {
  const TransferPointsScreen({super.key, required this.availableBalance});

  final int availableBalance;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<TransferPointsBloc>(param1: availableBalance),
      child: const TransferPointsEffectsListener(child: TransferPointsView()),
    );
  }
}
