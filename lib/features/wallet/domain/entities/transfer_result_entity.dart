import 'package:equatable/equatable.dart';

final class TransferResultEntity extends Equatable {
  const TransferResultEntity({
    required this.transactionId,
    required this.points,
    required this.newBalance,
    required this.status,
  });

  final String transactionId;
  final int points;
  final int newBalance;
  final String status;

  TransferResultEntity copyWith({
    String? transactionId,
    int? points,
    int? newBalance,
    String? status,
  }) {
    return TransferResultEntity(
      transactionId: transactionId ?? this.transactionId,
      points: points ?? this.points,
      newBalance: newBalance ?? this.newBalance,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [transactionId, points, newBalance, status];
}
