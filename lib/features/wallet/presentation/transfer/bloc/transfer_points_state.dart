import 'package:equatable/equatable.dart';

import '../../../domain/entities/transfer_result_entity.dart';
import '../../../domain/entities/wallet_exception.dart';

enum TransferValidationError {
  invalidRecipient,
  minimumPoints,
  wholeNumber,
  exceedsBalance,
  noteTooLong,
}

final class TransferPointsState extends Equatable {
  const TransferPointsState({
    this.recipient = '',
    this.pointsText = '',
    this.note = '',
    required this.availableBalance,
    this.recipientError,
    this.pointsError,
    this.noteError,
    this.isValid = false,
    this.isSubmitting = false,
    this.submissionErrorCode,
    this.successResult,
    this.successRequestId = 0,
  });

  final String recipient;
  final String pointsText;
  final String note;
  final int availableBalance;
  final TransferValidationError? recipientError;
  final TransferValidationError? pointsError;
  final TransferValidationError? noteError;
  final bool isValid;
  final bool isSubmitting;
  final WalletExceptionCode? submissionErrorCode;
  final TransferResultEntity? successResult;
  final int successRequestId;

  TransferPointsState copyWith({
    String? recipient,
    String? pointsText,
    String? note,
    int? availableBalance,
    TransferValidationError? recipientError,
    TransferValidationError? pointsError,
    TransferValidationError? noteError,
    bool? isValid,
    bool? isSubmitting,
    WalletExceptionCode? submissionErrorCode,
    TransferResultEntity? successResult,
    int? successRequestId,
    bool clearRecipientError = false,
    bool clearPointsError = false,
    bool clearNoteError = false,
    bool clearSubmissionError = false,
    bool clearSuccessResult = false,
  }) {
    return TransferPointsState(
      recipient: recipient ?? this.recipient,
      pointsText: pointsText ?? this.pointsText,
      note: note ?? this.note,
      availableBalance: availableBalance ?? this.availableBalance,
      recipientError: clearRecipientError
          ? null
          : (recipientError ?? this.recipientError),
      pointsError: clearPointsError ? null : (pointsError ?? this.pointsError),
      noteError: clearNoteError ? null : (noteError ?? this.noteError),
      isValid: isValid ?? this.isValid,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      submissionErrorCode: clearSubmissionError
          ? null
          : (submissionErrorCode ?? this.submissionErrorCode),
      successResult: clearSuccessResult
          ? null
          : (successResult ?? this.successResult),
      successRequestId: successRequestId ?? this.successRequestId,
    );
  }

  @override
  List<Object?> get props => [
    recipient,
    pointsText,
    note,
    availableBalance,
    recipientError,
    pointsError,
    noteError,
    isValid,
    isSubmitting,
    submissionErrorCode,
    successResult,
    successRequestId,
  ];
}
