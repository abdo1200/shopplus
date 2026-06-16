import 'merchant_balance_model.dart';

final class PointsBalanceModel {
  const PointsBalanceModel({
    required this.totalPoints,
    required this.pendingPoints,
    required this.expiringPoints,
    required this.expiringDate,
    required this.lastUpdated,
    required this.balancesByMerchant,
  });

  factory PointsBalanceModel.fromJson(Map<String, dynamic> json) {
    final merchantBalances = json['balancesByMerchant'] as List<dynamic>;

    return PointsBalanceModel(
      totalPoints: json['totalPoints'] as int,
      pendingPoints: json['pendingPoints'] as int,
      expiringPoints: json['expiringPoints'] as int,
      expiringDate: DateTime.parse(json['expiringDate'] as String),
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
      balancesByMerchant: merchantBalances
          .map(
            (merchant) =>
                MerchantBalanceModel.fromJson(merchant as Map<String, dynamic>),
          )
          .toList(growable: false),
    );
  }

  final int totalPoints;
  final int pendingPoints;
  final int expiringPoints;
  final DateTime expiringDate;
  final DateTime lastUpdated;
  final List<MerchantBalanceModel> balancesByMerchant;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'totalPoints': totalPoints,
      'pendingPoints': pendingPoints,
      'expiringPoints': expiringPoints,
      'expiringDate': expiringDate.toIso8601String(),
      'lastUpdated': lastUpdated.toIso8601String(),
      'balancesByMerchant': balancesByMerchant
          .map((merchant) => merchant.toJson())
          .toList(growable: false),
    };
  }

  PointsBalanceModel copyWith({
    int? totalPoints,
    int? pendingPoints,
    int? expiringPoints,
    DateTime? expiringDate,
    DateTime? lastUpdated,
    List<MerchantBalanceModel>? balancesByMerchant,
  }) {
    return PointsBalanceModel(
      totalPoints: totalPoints ?? this.totalPoints,
      pendingPoints: pendingPoints ?? this.pendingPoints,
      expiringPoints: expiringPoints ?? this.expiringPoints,
      expiringDate: expiringDate ?? this.expiringDate,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      balancesByMerchant: balancesByMerchant ?? this.balancesByMerchant,
    );
  }
}
