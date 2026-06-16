import '../entities/points_balance_entity.dart';
import '../repositories/wallet_repository.dart';

final class GetWalletBalanceUseCase {
  const GetWalletBalanceUseCase(this._repository);

  final WalletRepository _repository;

  Future<PointsBalanceEntity> call() {
    return _repository.getBalance();
  }
}
