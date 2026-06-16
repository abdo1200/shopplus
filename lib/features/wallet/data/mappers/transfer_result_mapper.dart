import '../../domain/entities/transfer_result_entity.dart';
import '../models/transfer_result_model.dart';

extension TransferResultModelMapper on TransferResultModel {
  TransferResultEntity get toEntity {
    return TransferResultEntity(
      transactionId: transactionId,
      points: points,
      newBalance: newBalance,
      status: status,
    );
  }
}
