enum WalletExceptionCode {
  invalidTransferAmount,
  insufficientBalance,
  recipientNotFound,
  unexpected,
}

final class WalletException implements Exception {
  const WalletException(this.code, this.message);

  final WalletExceptionCode code;
  final String message;

  @override
  String toString() => 'WalletException($code, $message)';
}
