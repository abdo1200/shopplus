import '../entities/paginated_transactions_entity.dart';
import '../entities/points_balance_entity.dart';
import '../entities/transfer_result_entity.dart';
import '../params/get_transactions_params.dart';
import '../params/transfer_request_params.dart';

abstract interface class WalletRepository {
  Future<PointsBalanceEntity> getBalance();

  Future<PaginatedTransactionsEntity> getTransactions(
    GetTransactionsParams params,
  );

  Future<TransferResultEntity> transferPoints(TransferRequestParams params);
}
