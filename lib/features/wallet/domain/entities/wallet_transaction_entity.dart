import 'package:equatable/equatable.dart';

enum WalletTransactionType { earn, redeem, transferIn, transferOut, purchase }

enum WalletTransactionStatus { completed, pending }

final class WalletTransactionEntity extends Equatable {
  const WalletTransactionEntity({
    required this.id,
    required this.type,
    required this.points,
    required this.description,
    required this.createdAt,
    required this.status,
    this.merchantName,
    this.merchantLogo,
  });

  final String id;
  final WalletTransactionType type;
  final int points;
  final String description;
  final String? merchantName;
  final String? merchantLogo;
  final DateTime createdAt;
  final WalletTransactionStatus status;

  bool get isPositive => points > 0;

  WalletTransactionEntity copyWith({
    String? id,
    WalletTransactionType? type,
    int? points,
    String? description,
    String? merchantName,
    String? merchantLogo,
    DateTime? createdAt,
    WalletTransactionStatus? status,
  }) {
    return WalletTransactionEntity(
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

  @override
  List<Object?> get props => [
    id,
    type,
    points,
    description,
    merchantName,
    merchantLogo,
    createdAt,
    status,
  ];
}
