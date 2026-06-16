import '../entities/paginated_transactions_entity.dart';
import '../params/get_transactions_params.dart';
import '../repositories/wallet_repository.dart';

final class GetWalletTransactionsUseCase {
  const GetWalletTransactionsUseCase(this._repository);

  final WalletRepository _repository;

  Future<PaginatedTransactionsEntity> call(GetTransactionsParams params) {
    return _repository.getTransactions(params);
  }
}
