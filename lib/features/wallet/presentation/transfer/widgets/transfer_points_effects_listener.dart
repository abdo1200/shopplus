import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shopplus/core/extensions/localizations_extension.dart';
import 'package:shopplus/features/wallet/presentation/transfer/bloc/transfer_points_bloc.dart';
import 'package:shopplus/features/wallet/presentation/transfer/bloc/transfer_points_event.dart';
import 'package:shopplus/features/wallet/presentation/transfer/bloc/transfer_points_state.dart';

class TransferPointsEffectsListener extends StatelessWidget {
  const TransferPointsEffectsListener({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocListener<TransferPointsBloc, TransferPointsState>(
      listenWhen: (previous, current) =>
          previous.successRequestId != current.successRequestId,
      listener: (context, state) async {
        final result = state.successResult;
        if (result == null) return;

        await showDialog<void>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(context.l10n.transferSuccessTitle),
            content: Text(
              context.l10n.transferSuccessMessage(
                points: result.points,
                balance: result.newBalance,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(context.l10n.done),
              ),
            ],
          ),
        );

        if (!context.mounted) return;
        context.read<TransferPointsBloc>().add(const TransferEffectHandled());
        context.pop(result.newBalance);
      },
      child: child,
    );
  }
}
