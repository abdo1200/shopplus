import 'package:equatable/equatable.dart';

final class MerchantBalanceEntity extends Equatable {
  const MerchantBalanceEntity({
    required this.merchantId,
    required this.merchantName,
    required this.merchantLogo,
    required this.points,
    required this.tier,
  });

  final String merchantId;
  final String merchantName;
  final String merchantLogo;
  final int points;
  final String tier;

  MerchantBalanceEntity copyWith({
    String? merchantId,
    String? merchantName,
    String? merchantLogo,
    int? points,
    String? tier,
  }) {
    return MerchantBalanceEntity(
      merchantId: merchantId ?? this.merchantId,
      merchantName: merchantName ?? this.merchantName,
      merchantLogo: merchantLogo ?? this.merchantLogo,
      points: points ?? this.points,
      tier: tier ?? this.tier,
    );
  }

  @override
  List<Object?> get props => [
    merchantId,
    merchantName,
    merchantLogo,
    points,
    tier,
  ];
}
