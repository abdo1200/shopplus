import 'dart:collection';

import 'package:equatable/equatable.dart';

import 'merchant_balance_entity.dart';

final class PointsBalanceEntity extends Equatable {
  const PointsBalanceEntity({
    required this.totalPoints,
    required this.pendingPoints,
    required this.expiringPoints,
    required this.expiringDate,
    required this.lastUpdated,
    required List<MerchantBalanceEntity> balancesByMerchant,
  }) : _balancesByMerchant = balancesByMerchant;

  final int totalPoints;
  final int pendingPoints;
  final int expiringPoints;
  final DateTime expiringDate;
  final DateTime lastUpdated;
  final List<MerchantBalanceEntity> _balancesByMerchant;

  UnmodifiableListView<MerchantBalanceEntity> get balancesByMerchant {
    return UnmodifiableListView<MerchantBalanceEntity>(_balancesByMerchant);
  }

  PointsBalanceEntity copyWith({
    int? totalPoints,
    int? pendingPoints,
    int? expiringPoints,
    DateTime? expiringDate,
    DateTime? lastUpdated,
    List<MerchantBalanceEntity>? balancesByMerchant,
  }) {
    return PointsBalanceEntity(
      totalPoints: totalPoints ?? this.totalPoints,
      pendingPoints: pendingPoints ?? this.pendingPoints,
      expiringPoints: expiringPoints ?? this.expiringPoints,
      expiringDate: expiringDate ?? this.expiringDate,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      balancesByMerchant: balancesByMerchant ?? _balancesByMerchant,
    );
  }

  @override
  List<Object?> get props => [
    totalPoints,
    pendingPoints,
    expiringPoints,
    expiringDate,
    lastUpdated,
    _balancesByMerchant,
  ];
}
