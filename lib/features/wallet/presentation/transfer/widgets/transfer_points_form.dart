import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shopplus/core/design_system/widgets/shopplus_primary_button.dart';
import 'package:shopplus/core/design_system/widgets/shopplus_text_field.dart';
import 'package:shopplus/core/extensions/localizations_extension.dart';
import 'package:shopplus/features/wallet/domain/entities/wallet_exception.dart';
import 'package:shopplus/features/wallet/presentation/transfer/bloc/transfer_points_bloc.dart';
import 'package:shopplus/features/wallet/presentation/transfer/bloc/transfer_points_event.dart';
import 'package:shopplus/features/wallet/presentation/transfer/bloc/transfer_points_state.dart';

class TransferPointsForm extends StatefulWidget {
  const TransferPointsForm({super.key, required this.state});

  final TransferPointsState state;

  @override
  State<TransferPointsForm> createState() => _TransferPointsFormState();
}

class _TransferPointsFormState extends State<TransferPointsForm> {
  late final TextEditingController _recipientController;
  late final TextEditingController _pointsController;
  late final TextEditingController _noteController;

  @override
  void initState() {
    super.initState();
    _recipientController = TextEditingController(text: widget.state.recipient);
    _pointsController = TextEditingController(text: widget.state.pointsText);
    _noteController = TextEditingController(text: widget.state.note);
  }

  @override
  void didUpdateWidget(covariant TransferPointsForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    _sync(_recipientController, widget.state.recipient);
    _sync(_pointsController, widget.state.pointsText);
    _sync(_noteController, widget.state.note);
  }

  @override
  void dispose() {
    _recipientController.dispose();
    _pointsController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.state;
    final numberFormat = NumberFormat.decimalPattern(
      Localizations.localeOf(context).toLanguageTag(),
    );
    final colorScheme = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              '${context.l10n.availableBalance}: ${numberFormat.format(state.availableBalance)}',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 16),
            ShopPlusTextField(
              controller: _recipientController,
              label: context.l10n.recipientLabel,
              errorText: _validationError(context, state.recipientError),
              keyboardType: TextInputType.emailAddress,
              onChanged: (value) => context.read<TransferPointsBloc>().add(
                TransferRecipientChanged(value),
              ),
            ),
            const SizedBox(height: 12),
            ShopPlusTextField(
              controller: _pointsController,
              label: context.l10n.pointsAmountLabel,
              errorText: _validationError(context, state.pointsError),
              keyboardType: TextInputType.number,
              onChanged: (value) => context.read<TransferPointsBloc>().add(
                TransferPointsChanged(value),
              ),
            ),
            const SizedBox(height: 12),
            ShopPlusTextField(
              controller: _noteController,
              label: '${context.l10n.noteLabel} (${context.l10n.noteOptional})',
              errorText: _validationError(context, state.noteError),
              maxLength: 150,
              maxLines: 3,
              onChanged: (value) => context.read<TransferPointsBloc>().add(
                TransferNoteChanged(value),
              ),
            ),
            if (state.submissionErrorCode != null) ...[
              const SizedBox(height: 8),
              Text(
                _submissionError(context, state.submissionErrorCode!),
                style: TextStyle(color: colorScheme.error),
              ),
            ],
            const SizedBox(height: 16),
            ShopPlusPrimaryButton(
              label: context.l10n.sendPoints,
              isLoading: state.isSubmitting,
              onPressed: state.isValid && !state.isSubmitting
                  ? () => context.read<TransferPointsBloc>().add(
                      const TransferSubmitted(),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  void _sync(TextEditingController controller, String value) {
    if (controller.text == value) return;
    controller.value = TextEditingValue(
      text: value,
      selection: TextSelection.collapsed(offset: value.length),
    );
  }

  String? _validationError(
    BuildContext context,
    TransferValidationError? error,
  ) {
    return switch (error) {
      null => null,
      TransferValidationError.invalidRecipient => context.l10n.recipientInvalid,
      TransferValidationError.minimumPoints => context.l10n.pointsMinimum,
      TransferValidationError.wholeNumber => context.l10n.pointsWholeNumber,
      TransferValidationError.exceedsBalance =>
        context.l10n.pointsExceedBalance,
      TransferValidationError.noteTooLong => context.l10n.noteTooLong,
    };
  }

  String _submissionError(BuildContext context, WalletExceptionCode code) {
    return switch (code) {
      WalletExceptionCode.invalidTransferAmount => context.l10n.pointsMinimum,
      WalletExceptionCode.insufficientBalance =>
        context.l10n.insufficientBalance,
      WalletExceptionCode.recipientNotFound => context.l10n.recipientNotFound,
      WalletExceptionCode.unexpected => context.l10n.unexpectedError,
    };
  }
}
