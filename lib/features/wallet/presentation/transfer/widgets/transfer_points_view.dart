import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopplus/core/extensions/localizations_extension.dart';
import 'package:shopplus/features/wallet/presentation/transfer/bloc/transfer_points_bloc.dart';
import 'package:shopplus/features/wallet/presentation/transfer/bloc/transfer_points_state.dart';
import 'package:shopplus/features/wallet/presentation/transfer/widgets/transfer_points_form.dart';

class TransferPointsView extends StatelessWidget {
  const TransferPointsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.transferPoints)),
      body: BlocBuilder<TransferPointsBloc, TransferPointsState>(
        builder: (context, state) {
          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 560),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: TransferPointsForm(state: state),
              ),
            ),
          );
        },
      ),
    );
  }
}
