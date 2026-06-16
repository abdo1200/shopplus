final class TransferResultModel {
  const TransferResultModel({
    required this.transactionId,
    required this.points,
    required this.newBalance,
    required this.status,
  });

  factory TransferResultModel.fromJson(Map<String, dynamic> json) {
    return TransferResultModel(
      transactionId: json['transactionId'] as String,
      points: json['points'] as int,
      newBalance: json['newBalance'] as int,
      status: json['status'] as String,
    );
  }

  final String transactionId;
  final int points;
  final int newBalance;
  final String status;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'transactionId': transactionId,
      'points': points,
      'newBalance': newBalance,
      'status': status,
    };
  }

  TransferResultModel copyWith({
    String? transactionId,
    int? points,
    int? newBalance,
    String? status,
  }) {
    return TransferResultModel(
      transactionId: transactionId ?? this.transactionId,
      points: points ?? this.points,
      newBalance: newBalance ?? this.newBalance,
      status: status ?? this.status,
    );
  }
}
