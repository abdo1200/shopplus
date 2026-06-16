import 'package:equatable/equatable.dart';

import '../entities/wallet_transaction_entity.dart';

final class GetTransactionsParams extends Equatable {
  const GetTransactionsParams({this.page = 1, this.limit = 20, this.type});

  final int page;
  final int limit;
  final WalletTransactionType? type;

  @override
  List<Object?> get props => [page, limit, type];
}
