import '../../domain/entities/points_balance_entity.dart';
import '../models/points_balance_model.dart';
import 'merchant_balance_mapper.dart';

extension PointsBalanceModelMapper on PointsBalanceModel {
  PointsBalanceEntity get toEntity {
    return PointsBalanceEntity(
      totalPoints: totalPoints,
      pendingPoints: pendingPoints,
      expiringPoints: expiringPoints,
      expiringDate: expiringDate,
      lastUpdated: lastUpdated,
      balancesByMerchant: balancesByMerchant
          .map((merchant) => merchant.toEntity)
          .toList(growable: false),
    );
  }
}
