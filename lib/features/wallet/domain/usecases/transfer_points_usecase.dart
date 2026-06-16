import '../entities/transfer_result_entity.dart';
import '../params/transfer_request_params.dart';
import '../repositories/wallet_repository.dart';

final class TransferPointsUseCase {
  const TransferPointsUseCase(this._repository);

  final WalletRepository _repository;

  Future<TransferResultEntity> call(TransferRequestParams params) {
    return _repository.transferPoints(params);
  }
}
