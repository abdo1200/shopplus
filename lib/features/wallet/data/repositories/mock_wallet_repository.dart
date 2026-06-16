import '../../domain/entities/paginated_transactions_entity.dart';
import '../../domain/entities/points_balance_entity.dart';
import '../../domain/entities/transfer_result_entity.dart';
import '../../domain/entities/wallet_exception.dart';
import '../../domain/entities/wallet_transaction_entity.dart';
import '../../domain/params/get_transactions_params.dart';
import '../../domain/params/transfer_request_params.dart';
import '../../domain/repositories/wallet_repository.dart';
import '../mappers/points_balance_mapper.dart';
import '../mappers/transfer_result_mapper.dart';
import '../mappers/wallet_transaction_mapper.dart';
import '../models/merchant_balance_model.dart';
import '../models/points_balance_model.dart';
import '../models/transfer_result_model.dart';
import '../models/wallet_transaction_model.dart';

final class MockWalletRepository implements WalletRepository {
  MockWalletRepository({Duration delay = const Duration(milliseconds: 800)})
    : _delay = delay,
      _currentBalanceModel = _mockBalanceModel,
      _transactions = List<WalletTransactionModel>.of(_mockTransactions);

  final Duration _delay;
  PointsBalanceModel _currentBalanceModel;
  final List<WalletTransactionModel> _transactions;

  @override
  Future<PointsBalanceEntity> getBalance() async {
    await Future<void>.delayed(_delay);
    return _currentBalanceModel.toEntity;
  }

  @override
  Future<PaginatedTransactionsEntity> getTransactions(
    GetTransactionsParams params,
  ) async {
    _validateTransactionsParams(params);

    await Future<void>.delayed(_delay);

    final filtered = params.type == null
        ? _transactions
        : _transactions
              .where((transaction) => transaction.type == params.type)
              .toList(growable: false);

    final startIndex = (params.page - 1) * params.limit;
    if (startIndex >= filtered.length) {
      return PaginatedTransactionsEntity(
        transactions: const [],
        page: params.page,
        totalItems: filtered.length,
        hasNext: false,
      );
    }

    final endIndex = (startIndex + params.limit).clamp(0, filtered.length);
    final pageData = filtered.sublist(startIndex, endIndex);

    return PaginatedTransactionsEntity(
      transactions: pageData
          .map((transaction) => transaction.toEntity)
          .toList(growable: false),
      page: params.page,
      totalItems: filtered.length,
      hasNext: endIndex < filtered.length,
    );
  }

  @override
  Future<TransferResultEntity> transferPoints(
    TransferRequestParams params,
  ) async {
    await Future<void>.delayed(_delay);

    if (params.points <= 0) {
      throw const WalletException(
        WalletExceptionCode.invalidTransferAmount,
        'Transfer points must be greater than zero',
      );
    }

    if (params.points > _currentBalanceModel.totalPoints) {
      throw const WalletException(
        WalletExceptionCode.insufficientBalance,
        'You do not have enough points',
      );
    }

    if (params.recipient == 'notfound@test.com') {
      throw const WalletException(
        WalletExceptionCode.recipientNotFound,
        'Recipient not found',
      );
    }

    final transactionId = 'txn_${DateTime.now().millisecondsSinceEpoch}';
    final newBalance = _currentBalanceModel.totalPoints - params.points;

    _currentBalanceModel = _currentBalanceModel.copyWith(
      totalPoints: newBalance,
    );
    _transactions.insert(
      0,
      WalletTransactionModel(
        id: transactionId,
        type: WalletTransactionType.transferOut,
        points: -params.points,
        description: 'Transfer to ${params.recipient}',
        createdAt: DateTime.now().toUtc(),
        status: WalletTransactionStatus.completed,
      ),
    );

    return TransferResultModel(
      transactionId: transactionId,
      points: params.points,
      newBalance: newBalance,
      status: 'COMPLETED',
    ).toEntity;
  }
}

void _validateTransactionsParams(GetTransactionsParams params) {
  if (params.page < 1) {
    throw ArgumentError.value(
      params.page,
      'page',
      'Page must be greater than zero',
    );
  }

  if (params.limit < 1) {
    throw ArgumentError.value(
      params.limit,
      'limit',
      'Limit must be greater than zero',
    );
  }
}

final _mockBalanceModel = PointsBalanceModel(
  totalPoints: 15750,
  pendingPoints: 500,
  expiringPoints: 1200,
  expiringDate: DateTime.parse('2024-03-31T23:59:59Z'),
  lastUpdated: DateTime.parse('2024-02-15T10:30:00Z'),
  balancesByMerchant: const [
    MerchantBalanceModel(
      merchantId: 'merchant_001',
      merchantName: 'TechMart',
      merchantLogo: 'https://picsum.photos/seed/techmart/100',
      points: 8500,
      tier: 'Gold',
    ),
    MerchantBalanceModel(
      merchantId: 'merchant_002',
      merchantName: 'FoodMart',
      merchantLogo: 'https://picsum.photos/seed/foodmart/100',
      points: 4250,
      tier: 'Silver',
    ),
    MerchantBalanceModel(
      merchantId: 'merchant_003',
      merchantName: 'StyleHub',
      merchantLogo: 'https://picsum.photos/seed/stylehub/100',
      points: 3000,
      tier: 'Bronze',
    ),
  ],
);

final _mockTransactions = <WalletTransactionModel>[
  WalletTransactionModel(
    id: 'txn_001',
    type: WalletTransactionType.earn,
    points: 500,
    description: 'Purchase at TechMart',
    merchantName: 'TechMart',
    merchantLogo: 'https://picsum.photos/seed/techmart/100',
    createdAt: DateTime.parse('2024-02-15T14:30:00Z'),
    status: WalletTransactionStatus.completed,
  ),
  WalletTransactionModel(
    id: 'txn_002',
    type: WalletTransactionType.redeem,
    points: -1000,
    description: 'Discount redemption',
    merchantName: 'FoodMart',
    merchantLogo: 'https://picsum.photos/seed/foodmart/100',
    createdAt: DateTime.parse('2024-02-14T11:20:00Z'),
    status: WalletTransactionStatus.completed,
  ),
  WalletTransactionModel(
    id: 'txn_003',
    type: WalletTransactionType.transferOut,
    points: -250,
    description: 'Transfer to Ahmed M.',
    createdAt: DateTime.parse('2024-02-13T09:15:00Z'),
    status: WalletTransactionStatus.completed,
  ),
  WalletTransactionModel(
    id: 'txn_004',
    type: WalletTransactionType.earn,
    points: 750,
    description: 'Online order #ORD-2024-089',
    merchantName: 'StyleHub',
    merchantLogo: 'https://picsum.photos/seed/stylehub/100',
    createdAt: DateTime.parse('2024-02-12T16:45:00Z'),
    status: WalletTransactionStatus.completed,
  ),
  WalletTransactionModel(
    id: 'txn_005',
    type: WalletTransactionType.transferIn,
    points: 300,
    description: 'Received from Sara K.',
    createdAt: DateTime.parse('2024-02-08T13:30:00Z'),
    status: WalletTransactionStatus.pending,
  ),
  ..._mockPaginationTransactions,
];

final _mockPaginationTransactions = <WalletTransactionModel>[
  WalletTransactionModel(
    id: 'txn_006',
    type: WalletTransactionType.earn,
    points: 650,
    description: 'Coffee supplies at FoodMart',
    merchantName: 'FoodMart',
    merchantLogo: 'https://picsum.photos/seed/foodmart/100',
    createdAt: DateTime.parse('2024-02-07T18:20:00Z'),
    status: WalletTransactionStatus.completed,
  ),
  WalletTransactionModel(
    id: 'txn_007',
    type: WalletTransactionType.earn,
    points: 120,
    description: 'TechMart loyalty bonus',
    merchantName: 'TechMart',
    merchantLogo: 'https://picsum.photos/seed/techmart/100',
    createdAt: DateTime.parse('2024-02-07T12:10:00Z'),
    status: WalletTransactionStatus.completed,
  ),
  WalletTransactionModel(
    id: 'txn_008',
    type: WalletTransactionType.redeem,
    points: -400,
    description: 'FoodMart checkout discount',
    merchantName: 'FoodMart',
    merchantLogo: 'https://picsum.photos/seed/foodmart/100',
    createdAt: DateTime.parse('2024-02-06T19:45:00Z'),
    status: WalletTransactionStatus.completed,
  ),
  WalletTransactionModel(
    id: 'txn_009',
    type: WalletTransactionType.transferIn,
    points: 220,
    description: 'Received from Omar H.',
    createdAt: DateTime.parse('2024-02-06T15:05:00Z'),
    status: WalletTransactionStatus.pending,
  ),
  WalletTransactionModel(
    id: 'txn_010',
    type: WalletTransactionType.earn,
    points: 900,
    description: 'Laptop accessories order',
    merchantName: 'TechMart',
    merchantLogo: 'https://picsum.photos/seed/techmart/100',
    createdAt: DateTime.parse('2024-02-05T16:30:00Z'),
    status: WalletTransactionStatus.completed,
  ),
  WalletTransactionModel(
    id: 'txn_011',
    type: WalletTransactionType.transferOut,
    points: -180,
    description: 'Transfer to Nada S.',
    createdAt: DateTime.parse('2024-02-05T10:25:00Z'),
    status: WalletTransactionStatus.completed,
  ),
  WalletTransactionModel(
    id: 'txn_012',
    type: WalletTransactionType.earn,
    points: 80,
    description: 'Weekend grocery bonus',
    merchantName: 'FoodMart',
    merchantLogo: 'https://picsum.photos/seed/foodmart/100',
    createdAt: DateTime.parse('2024-02-04T20:00:00Z'),
    status: WalletTransactionStatus.completed,
  ),
  WalletTransactionModel(
    id: 'txn_013',
    type: WalletTransactionType.earn,
    points: 300,
    description: 'StyleHub online purchase',
    merchantName: 'StyleHub',
    merchantLogo: 'https://picsum.photos/seed/stylehub/100',
    createdAt: DateTime.parse('2024-02-04T14:40:00Z'),
    status: WalletTransactionStatus.completed,
  ),
  WalletTransactionModel(
    id: 'txn_014',
    type: WalletTransactionType.redeem,
    points: -700,
    description: 'TechMart voucher redemption',
    merchantName: 'TechMart',
    merchantLogo: 'https://picsum.photos/seed/techmart/100',
    createdAt: DateTime.parse('2024-02-03T17:15:00Z'),
    status: WalletTransactionStatus.completed,
  ),
  WalletTransactionModel(
    id: 'txn_015',
    type: WalletTransactionType.transferIn,
    points: 450,
    description: 'Received from Kareem A.',
    createdAt: DateTime.parse('2024-02-03T11:50:00Z'),
    status: WalletTransactionStatus.completed,
  ),
  WalletTransactionModel(
    id: 'txn_016',
    type: WalletTransactionType.earn,
    points: 1100,
    description: 'Monthly FoodMart order',
    merchantName: 'FoodMart',
    merchantLogo: 'https://picsum.photos/seed/foodmart/100',
    createdAt: DateTime.parse('2024-02-02T18:35:00Z'),
    status: WalletTransactionStatus.completed,
  ),
  WalletTransactionModel(
    id: 'txn_017',
    type: WalletTransactionType.earn,
    points: 60,
    description: 'StyleHub review reward',
    merchantName: 'StyleHub',
    merchantLogo: 'https://picsum.photos/seed/stylehub/100',
    createdAt: DateTime.parse('2024-02-02T09:30:00Z'),
    status: WalletTransactionStatus.completed,
  ),
  WalletTransactionModel(
    id: 'txn_018',
    type: WalletTransactionType.transferOut,
    points: -320,
    description: 'Transfer to Youssef R.',
    createdAt: DateTime.parse('2024-02-01T21:10:00Z'),
    status: WalletTransactionStatus.pending,
  ),
  WalletTransactionModel(
    id: 'txn_019',
    type: WalletTransactionType.redeem,
    points: -250,
    description: 'FoodMart coupon redemption',
    merchantName: 'FoodMart',
    merchantLogo: 'https://picsum.photos/seed/foodmart/100',
    createdAt: DateTime.parse('2024-02-01T12:25:00Z'),
    status: WalletTransactionStatus.completed,
  ),
  WalletTransactionModel(
    id: 'txn_020',
    type: WalletTransactionType.earn,
    points: 520,
    description: 'TechMart cable purchase',
    merchantName: 'TechMart',
    merchantLogo: 'https://picsum.photos/seed/techmart/100',
    createdAt: DateTime.parse('2024-01-31T16:55:00Z'),
    status: WalletTransactionStatus.completed,
  ),
  WalletTransactionModel(
    id: 'txn_021',
    type: WalletTransactionType.earn,
    points: 140,
    description: 'TechMart referral reward',
    merchantName: 'TechMart',
    merchantLogo: 'https://picsum.photos/seed/techmart/100',
    createdAt: DateTime.parse('2024-01-31T08:45:00Z'),
    status: WalletTransactionStatus.completed,
  ),
  WalletTransactionModel(
    id: 'txn_022',
    type: WalletTransactionType.earn,
    points: 260,
    description: 'StyleHub basics order',
    merchantName: 'StyleHub',
    merchantLogo: 'https://picsum.photos/seed/stylehub/100',
    createdAt: DateTime.parse('2024-01-30T18:00:00Z'),
    status: WalletTransactionStatus.completed,
  ),
  WalletTransactionModel(
    id: 'txn_023',
    type: WalletTransactionType.transferIn,
    points: 600,
    description: 'Received from Laila T.',
    createdAt: DateTime.parse('2024-01-30T13:20:00Z'),
    status: WalletTransactionStatus.completed,
  ),
  WalletTransactionModel(
    id: 'txn_024',
    type: WalletTransactionType.redeem,
    points: -350,
    description: 'StyleHub discount redemption',
    merchantName: 'StyleHub',
    merchantLogo: 'https://picsum.photos/seed/stylehub/100',
    createdAt: DateTime.parse('2024-01-29T17:40:00Z'),
    status: WalletTransactionStatus.completed,
  ),
  WalletTransactionModel(
    id: 'txn_025',
    type: WalletTransactionType.earn,
    points: 430,
    description: 'FoodMart household order',
    merchantName: 'FoodMart',
    merchantLogo: 'https://picsum.photos/seed/foodmart/100',
    createdAt: DateTime.parse('2024-01-29T11:05:00Z'),
    status: WalletTransactionStatus.completed,
  ),
  WalletTransactionModel(
    id: 'txn_026',
    type: WalletTransactionType.transferOut,
    points: -150,
    description: 'Transfer to Mona E.',
    createdAt: DateTime.parse('2024-01-28T19:35:00Z'),
    status: WalletTransactionStatus.completed,
  ),
  WalletTransactionModel(
    id: 'txn_027',
    type: WalletTransactionType.earn,
    points: 95,
    description: 'FoodMart loyalty reward',
    merchantName: 'FoodMart',
    merchantLogo: 'https://picsum.photos/seed/foodmart/100',
    createdAt: DateTime.parse('2024-01-28T10:10:00Z'),
    status: WalletTransactionStatus.completed,
  ),
  WalletTransactionModel(
    id: 'txn_028',
    type: WalletTransactionType.earn,
    points: 780,
    description: 'TechMart smart home order',
    merchantName: 'TechMart',
    merchantLogo: 'https://picsum.photos/seed/techmart/100',
    createdAt: DateTime.parse('2024-01-27T15:50:00Z'),
    status: WalletTransactionStatus.completed,
  ),
  WalletTransactionModel(
    id: 'txn_029',
    type: WalletTransactionType.redeem,
    points: -500,
    description: 'FoodMart savings redemption',
    merchantName: 'FoodMart',
    merchantLogo: 'https://picsum.photos/seed/foodmart/100',
    createdAt: DateTime.parse('2024-01-27T09:15:00Z'),
    status: WalletTransactionStatus.completed,
  ),
  WalletTransactionModel(
    id: 'txn_030',
    type: WalletTransactionType.transferIn,
    points: 210,
    description: 'Received from Hassan P.',
    createdAt: DateTime.parse('2024-01-26T18:45:00Z'),
    status: WalletTransactionStatus.pending,
  ),
];
