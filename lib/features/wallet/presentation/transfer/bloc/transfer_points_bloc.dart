import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/wallet_exception.dart';
import '../../../domain/params/transfer_request_params.dart';
import '../../../domain/usecases/transfer_points_usecase.dart';
import 'transfer_points_event.dart';
import 'transfer_points_state.dart';

class TransferPointsBloc
    extends Bloc<TransferPointsEvent, TransferPointsState> {
  TransferPointsBloc({
    required TransferPointsUseCase transferPoints,
    required int availableBalance,
  }) : _transferPoints = transferPoints,
       super(TransferPointsState(availableBalance: availableBalance)) {
    on<TransferRecipientChanged>(_onRecipientChanged);
    on<TransferPointsChanged>(_onPointsChanged);
    on<TransferNoteChanged>(_onNoteChanged);
    on<TransferSubmitted>(_onSubmitted);
    on<TransferEffectHandled>(_onEffectHandled);
  }

  static final RegExp _emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
  static final RegExp _egyptianPhonePattern = RegExp(r'^\+20\d{10}$');
  static final RegExp _wholeNumberPattern = RegExp(r'^\d+$');
  static const int _minimumPoints = 100;
  static const int _maximumNoteLength = 150;

  final TransferPointsUseCase _transferPoints;

  void _onRecipientChanged(
    TransferRecipientChanged event,
    Emitter<TransferPointsState> emit,
  ) {
    emit(_validatedState(recipient: event.value));
  }

  void _onPointsChanged(
    TransferPointsChanged event,
    Emitter<TransferPointsState> emit,
  ) {
    emit(_validatedState(pointsText: event.value));
  }

  void _onNoteChanged(
    TransferNoteChanged event,
    Emitter<TransferPointsState> emit,
  ) {
    emit(_validatedState(note: event.value));
  }

  Future<void> _onSubmitted(
    TransferSubmitted event,
    Emitter<TransferPointsState> emit,
  ) async {
    final validated = _validatedState();
    if (!validated.isValid || validated.isSubmitting) {
      if (validated != state) {
        emit(validated);
      }
      return;
    }

    emit(
      validated.copyWith(
        isSubmitting: true,
        clearSubmissionError: true,
        clearSuccessResult: true,
      ),
    );

    try {
      final result = await _transferPoints(
        TransferRequestParams(
          recipient: validated.recipient.trim(),
          points: int.parse(validated.pointsText.trim()),
          note: _nullableNote(validated.note),
        ),
      );
      emit(
        TransferPointsState(
          availableBalance: result.newBalance,
          successResult: result,
          successRequestId: state.successRequestId + 1,
        ),
      );
    } on WalletException catch (error) {
      emit(
        state.copyWith(
          isSubmitting: false,
          submissionErrorCode: error.code,
          clearSuccessResult: true,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          isSubmitting: false,
          submissionErrorCode: WalletExceptionCode.unexpected,
          clearSuccessResult: true,
        ),
      );
    }
  }

  void _onEffectHandled(
    TransferEffectHandled event,
    Emitter<TransferPointsState> emit,
  ) {
    emit(state.copyWith(clearSubmissionError: true, clearSuccessResult: true));
  }

  TransferPointsState _validatedState({
    String? recipient,
    String? pointsText,
    String? note,
  }) {
    final nextRecipient = recipient ?? state.recipient;
    final nextPointsText = pointsText ?? state.pointsText;
    final nextNote = note ?? state.note;
    final recipientError = _recipientError(nextRecipient);
    final pointsError = _pointsError(nextPointsText);
    final noteError = _noteError(nextNote);
    final hasRequiredFields =
        nextRecipient.trim().isNotEmpty && nextPointsText.trim().isNotEmpty;
    final isValid =
        hasRequiredFields &&
        recipientError == null &&
        pointsError == null &&
        noteError == null;

    return state.copyWith(
      recipient: nextRecipient,
      pointsText: nextPointsText,
      note: nextNote,
      recipientError: recipientError,
      pointsError: pointsError,
      noteError: noteError,
      isValid: isValid,
      clearRecipientError: recipientError == null,
      clearPointsError: pointsError == null,
      clearNoteError: noteError == null,
      clearSubmissionError: true,
      clearSuccessResult: true,
    );
  }

  TransferValidationError? _recipientError(String value) {
    final recipient = value.trim();
    if (recipient.isEmpty) {
      return null;
    }
    if (_emailPattern.hasMatch(recipient) ||
        _egyptianPhonePattern.hasMatch(recipient)) {
      return null;
    }

    return TransferValidationError.invalidRecipient;
  }

  TransferValidationError? _pointsError(String value) {
    final pointsText = value.trim();
    if (pointsText.isEmpty) {
      return null;
    }
    if (!_wholeNumberPattern.hasMatch(pointsText)) {
      return TransferValidationError.wholeNumber;
    }

    final points = int.parse(pointsText);
    if (points < _minimumPoints) {
      return TransferValidationError.minimumPoints;
    }
    if (points > state.availableBalance) {
      return TransferValidationError.exceedsBalance;
    }

    return null;
  }

  TransferValidationError? _noteError(String value) {
    if (value.length > _maximumNoteLength) {
      return TransferValidationError.noteTooLong;
    }

    return null;
  }

  String? _nullableNote(String value) {
    final note = value.trim();
    if (note.isEmpty) {
      return null;
    }

    return note;
  }
}
