final class MerchantBalanceModel {
  const MerchantBalanceModel({
    required this.merchantId,
    required this.merchantName,
    required this.merchantLogo,
    required this.points,
    required this.tier,
  });

  factory MerchantBalanceModel.fromJson(Map<String, dynamic> json) {
    return MerchantBalanceModel(
      merchantId: json['merchantId'] as String,
      merchantName: json['merchantName'] as String,
      merchantLogo: json['merchantLogo'] as String,
      points: json['points'] as int,
      tier: json['tier'] as String,
    );
  }

  final String merchantId;
  final String merchantName;
  final String merchantLogo;
  final int points;
  final String tier;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'merchantId': merchantId,
      'merchantName': merchantName,
      'merchantLogo': merchantLogo,
      'points': points,
      'tier': tier,
    };
  }

  MerchantBalanceModel copyWith({
    String? merchantId,
    String? merchantName,
    String? merchantLogo,
    int? points,
    String? tier,
  }) {
    return MerchantBalanceModel(
      merchantId: merchantId ?? this.merchantId,
      merchantName: merchantName ?? this.merchantName,
      merchantLogo: merchantLogo ?? this.merchantLogo,
      points: points ?? this.points,
      tier: tier ?? this.tier,
    );
  }
}
