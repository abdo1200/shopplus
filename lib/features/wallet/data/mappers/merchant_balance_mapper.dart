import '../../domain/entities/merchant_balance_entity.dart';
import '../models/merchant_balance_model.dart';

extension MerchantBalanceModelMapper on MerchantBalanceModel {
  MerchantBalanceEntity get toEntity {
    return MerchantBalanceEntity(
      merchantId: merchantId,
      merchantName: merchantName,
      merchantLogo: merchantLogo,
      points: points,
      tier: tier,
    );
  }
}
