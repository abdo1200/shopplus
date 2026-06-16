import '../../domain/entities/wallet_transaction_entity.dart';
import '../models/wallet_transaction_model.dart';

extension WalletTransactionModelMapper on WalletTransactionModel {
  WalletTransactionEntity get toEntity {
    return WalletTransactionEntity(
      id: id,
      type: type,
      points: points,
      description: description,
      merchantName: merchantName,
      merchantLogo: merchantLogo,
      createdAt: createdAt,
      status: status,
    );
  }
}
