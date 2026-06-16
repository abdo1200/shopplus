import '../../domain/entities/paginated_transactions_entity.dart';
import '../models/paginated_transactions_model.dart';
import 'wallet_transaction_mapper.dart';

extension PaginatedTransactionsModelMapper on PaginatedTransactionsModel {
  PaginatedTransactionsEntity get toEntity {
    return PaginatedTransactionsEntity(
      transactions: transactions
          .map((transaction) => transaction.toEntity)
          .toList(growable: false),
      page: page,
      totalItems: totalItems,
      hasNext: hasNext,
    );
  }
}
