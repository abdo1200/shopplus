import '../../domain/entities/wallet_transaction_entity.dart';

WalletTransactionType walletTransactionTypeFromJson(String value) {
  return switch (value.toUpperCase()) {
    'EARN' => WalletTransactionType.earn,
    'REDEEM' => WalletTransactionType.redeem,
    'TRANSFER_IN' => WalletTransactionType.transferIn,
    'TRANSFER_OUT' => WalletTransactionType.transferOut,
    'PURCHASE' => WalletTransactionType.purchase,
    _ => throw ArgumentError.value(
      value,
      'value',
      'Unknown wallet transaction type',
    ),
  };
}

String walletTransactionTypeToJson(WalletTransactionType type) {
  return switch (type) {
    WalletTransactionType.earn => 'EARN',
    WalletTransactionType.redeem => 'REDEEM',
    WalletTransactionType.transferIn => 'TRANSFER_IN',
    WalletTransactionType.transferOut => 'TRANSFER_OUT',
    WalletTransactionType.purchase => 'PURCHASE',
  };
}

WalletTransactionStatus walletTransactionStatusFromJson(String value) {
  return switch (value.toUpperCase()) {
    'COMPLETED' => WalletTransactionStatus.completed,
    'PENDING' => WalletTransactionStatus.pending,
    _ => throw ArgumentError.value(
      value,
      'value',
      'Unknown wallet transaction status',
    ),
  };
}

String walletTransactionStatusToJson(WalletTransactionStatus status) {
  return switch (status) {
    WalletTransactionStatus.completed => 'COMPLETED',
    WalletTransactionStatus.pending => 'PENDING',
  };
}

final class WalletTransactionModel {
  const WalletTransactionModel({
    required this.id,
    required this.type,
    required this.points,
    required this.description,
    required this.createdAt,
    required this.status,
    this.merchantName,
    this.merchantLogo,
  });

  factory WalletTransactionModel.fromJson(Map<String, dynamic> json) {
    return WalletTransactionModel(
      id: json['id'] as String,
      type: walletTransactionTypeFromJson(json['type'] as String),
      points: json['points'] as int,
      description: json['description'] as String,
      merchantName: json['merchantName'] as String?,
      merchantLogo: json['merchantLogo'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      status: walletTransactionStatusFromJson(json['status'] as String),
    );
  }

  final String id;
  final WalletTransactionType type;
  final int points;
  final String description;
  final String? merchantName;
  final String? merchantLogo;
  final DateTime createdAt;
  final WalletTransactionStatus status;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'type': walletTransactionTypeToJson(type),
      'points': points,
      'description': description,
      'merchantName': merchantName,
      'merchantLogo': merchantLogo,
      'createdAt': createdAt.toIso8601String(),
      'status': walletTransactionStatusToJson(status),
    };
  }

  WalletTransactionModel copyWith({
    String? id,
    WalletTransactionType? type,
    int? points,
    String? description,
    String? merchantName,
    String? merchantLogo,
    DateTime? createdAt,
    WalletTransactionStatus? status,
  }) {
    return WalletTransactionModel(
      id: id ?? this.id,
      type: type ?? this.type,
      points: points ?? this.points,
      description: description ?? this.description,
      merchantName: merchantName ?? this.merchantName,
      merchantLogo: merchantLogo ?? this.merchantLogo,
      createdAt: createdAt ?? this.createdAt,
      status: status ?? this.status,
    );
  }
}
