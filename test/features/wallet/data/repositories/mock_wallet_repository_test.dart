import 'package:flutter_test/flutter_test.dart';
import 'package:shopplus/features/wallet/data/repositories/mock_wallet_repository.dart';
import 'package:shopplus/features/wallet/domain/entities/wallet_exception.dart';
import 'package:shopplus/features/wallet/domain/entities/wallet_transaction_entity.dart';
import 'package:shopplus/features/wallet/domain/params/get_transactions_params.dart';
import 'package:shopplus/features/wallet/domain/params/transfer_request_params.dart';

void main() {
  group('MockWalletRepository', () {
    late MockWalletRepository repository;

    setUp(() {
      repository = MockWalletRepository(delay: Duration.zero);
    });

    test('should return correct balance data', () async {
      final balance = await repository.getBalance();

      expect(balance.totalPoints, 15750);
      expect(balance.pendingPoints, 500);
      expect(balance.expiringPoints, 1200);
      expect(balance.balancesByMerchant, hasLength(3));
      expect(balance.balancesByMerchant.first.merchantName, 'TechMart');
      expect(balance.balancesByMerchant.first.points, 8500);
    });

    test('should return paginated transactions', () async {
      final page = await repository.getTransactions(
        const GetTransactionsParams(page: 1, limit: 10),
      );

      expect(page.transactions, hasLength(10));
      expect(page.page, 1);
      expect(page.totalItems, 30);
      expect(page.hasNext, isTrue);
      expect(page.transactions.first.id, 'txn_001');
    });

    test('should filter transactions by type', () async {
      final page = await repository.getTransactions(
        const GetTransactionsParams(type: WalletTransactionType.transferOut),
      );

      expect(page.transactions, isNotEmpty);
      expect(
        page.transactions.every(
          (transaction) =>
              transaction.type == WalletTransactionType.transferOut,
        ),
        isTrue,
      );
    });

    test('should transfer points successfully', () async {
      final result = await repository.transferPoints(
        const TransferRequestParams(recipient: 'friend@test.com', points: 500),
      );

      final balance = await repository.getBalance();

      expect(result.points, 500);
      expect(result.newBalance, 15250);
      expect(result.status, 'COMPLETED');
      expect(result.transactionId, startsWith('txn_'));
      expect(balance.totalPoints, 15250);
    });

    test(
      'should throw WalletException when transfer points are not positive',
      () async {
        for (final points in [0, -100]) {
          await expectLater(
            repository.transferPoints(
              TransferRequestParams(
                recipient: 'friend@test.com',
                points: points,
              ),
            ),
            throwsA(
              isA<WalletException>().having(
                (exception) => exception.code,
                'code',
                WalletExceptionCode.invalidTransferAmount,
              ),
            ),
          );
        }
      },
    );

    test('should throw WalletException when balance is insufficient', () async {
      await expectLater(
        repository.transferPoints(
          const TransferRequestParams(
            recipient: 'friend@test.com',
            points: 20000,
          ),
        ),
        throwsA(
          isA<WalletException>().having(
            (exception) => exception.code,
            'code',
            WalletExceptionCode.insufficientBalance,
          ),
        ),
      );
    });

    test('should throw WalletException when recipient is invalid', () async {
      await expectLater(
        repository.transferPoints(
          const TransferRequestParams(
            recipient: 'notfound@test.com',
            points: 500,
          ),
        ),
        throwsA(
          isA<WalletException>().having(
            (exception) => exception.code,
            'code',
            WalletExceptionCode.recipientNotFound,
          ),
        ),
      );
    });
  });
}
