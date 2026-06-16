import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shopplus/features/wallet/data/repositories/mock_wallet_repository.dart';
import 'package:shopplus/features/wallet/domain/entities/wallet_exception.dart';
import 'package:shopplus/features/wallet/domain/usecases/transfer_points_usecase.dart';
import 'package:shopplus/features/wallet/presentation/transfer/bloc/transfer_points_bloc.dart';
import 'package:shopplus/features/wallet/presentation/transfer/bloc/transfer_points_event.dart';
import 'package:shopplus/features/wallet/presentation/transfer/bloc/transfer_points_state.dart';

void main() {
  group('TransferPointsBloc', () {
    late MockWalletRepository repository;

    TransferPointsBloc buildBloc({int availableBalance = 15750}) {
      return TransferPointsBloc(
        transferPoints: TransferPointsUseCase(repository),
        availableBalance: availableBalance,
      );
    }

    setUp(() {
      repository = MockWalletRepository(delay: Duration.zero);
    });

    test('should start with initial state', () {
      final bloc = buildBloc();
      addTearDown(bloc.close);

      expect(bloc.state.availableBalance, 15750);
      expect(bloc.state.isValid, isFalse);
      expect(bloc.state.isSubmitting, isFalse);
      expect(bloc.state.successResult, isNull);
      expect(bloc.state.submissionErrorCode, isNull);
    });

    blocTest<TransferPointsBloc, TransferPointsState>(
      'should validate recipient format',
      build: buildBloc,
      act: (bloc) => bloc.add(const TransferRecipientChanged('invalid-user')),
      expect: () => [
        isA<TransferPointsState>()
            .having((state) => state.recipient, 'recipient', 'invalid-user')
            .having(
              (state) => state.recipientError,
              'recipientError',
              TransferValidationError.invalidRecipient,
            )
            .having((state) => state.isValid, 'isValid', isFalse),
      ],
    );

    blocTest<TransferPointsBloc, TransferPointsState>(
      'should validate points do not exceed available balance',
      build: buildBloc,
      act: (bloc) async {
        bloc.add(const TransferRecipientChanged('friend@test.com'));
        await Future<void>.delayed(Duration.zero);

        bloc.add(const TransferPointsChanged('20000'));
      },
      expect: () => [
        isA<TransferPointsState>()
            .having((state) => state.recipient, 'recipient', 'friend@test.com')
            .having((state) => state.isValid, 'isValid', isFalse),
        isA<TransferPointsState>()
            .having((state) => state.pointsText, 'pointsText', '20000')
            .having(
              (state) => state.pointsError,
              'pointsError',
              TransferValidationError.exceedsBalance,
            )
            .having((state) => state.isValid, 'isValid', isFalse),
      ],
    );

    blocTest<TransferPointsBloc, TransferPointsState>(
      'should submit transfer successfully',
      build: buildBloc,
      act: (bloc) async {
        bloc.add(const TransferRecipientChanged('friend@test.com'));
        await Future<void>.delayed(Duration.zero);

        bloc.add(const TransferPointsChanged('500'));
        await Future<void>.delayed(Duration.zero);

        bloc.add(const TransferSubmitted());
      },
      wait: const Duration(milliseconds: 1),
      expect: () => [
        isA<TransferPointsState>().having(
          (state) => state.recipient,
          'recipient',
          'friend@test.com',
        ),
        isA<TransferPointsState>()
            .having((state) => state.pointsText, 'pointsText', '500')
            .having((state) => state.isValid, 'isValid', isTrue),
        isA<TransferPointsState>().having(
          (state) => state.isSubmitting,
          'isSubmitting',
          isTrue,
        ),
        isA<TransferPointsState>()
            .having((state) => state.isSubmitting, 'isSubmitting', isFalse)
            .having(
              (state) => state.availableBalance,
              'availableBalance',
              15250,
            )
            .having(
              (state) => state.successResult?.newBalance,
              'successResult.newBalance',
              15250,
            )
            .having((state) => state.successRequestId, 'successRequestId', 1),
      ],
    );

    blocTest<TransferPointsBloc, TransferPointsState>(
      'should show insufficient balance error from repository',
      build: () => buildBloc(availableBalance: 20000),
      act: (bloc) async {
        bloc.add(const TransferRecipientChanged('friend@test.com'));
        await Future<void>.delayed(Duration.zero);

        bloc.add(const TransferPointsChanged('20000'));
        await Future<void>.delayed(Duration.zero);

        bloc.add(const TransferSubmitted());
      },
      wait: const Duration(milliseconds: 1),
      expect: () => [
        isA<TransferPointsState>().having(
          (state) => state.recipient,
          'recipient',
          'friend@test.com',
        ),
        isA<TransferPointsState>()
            .having((state) => state.pointsText, 'pointsText', '20000')
            .having((state) => state.isValid, 'isValid', isTrue),
        isA<TransferPointsState>().having(
          (state) => state.isSubmitting,
          'isSubmitting',
          isTrue,
        ),
        isA<TransferPointsState>()
            .having((state) => state.isSubmitting, 'isSubmitting', isFalse)
            .having(
              (state) => state.submissionErrorCode,
              'submissionErrorCode',
              WalletExceptionCode.insufficientBalance,
            ),
      ],
    );

    blocTest<TransferPointsBloc, TransferPointsState>(
      'should show invalid recipient error from repository',
      build: buildBloc,
      act: (bloc) async {
        bloc.add(const TransferRecipientChanged('notfound@test.com'));
        await Future<void>.delayed(Duration.zero);

        bloc.add(const TransferPointsChanged('500'));
        await Future<void>.delayed(Duration.zero);

        bloc.add(const TransferSubmitted());
      },
      wait: const Duration(milliseconds: 1),
      expect: () => [
        isA<TransferPointsState>().having(
          (state) => state.recipient,
          'recipient',
          'notfound@test.com',
        ),
        isA<TransferPointsState>()
            .having((state) => state.pointsText, 'pointsText', '500')
            .having((state) => state.isValid, 'isValid', isTrue),
        isA<TransferPointsState>().having(
          (state) => state.isSubmitting,
          'isSubmitting',
          isTrue,
        ),
        isA<TransferPointsState>()
            .having((state) => state.isSubmitting, 'isSubmitting', isFalse)
            .having(
              (state) => state.submissionErrorCode,
              'submissionErrorCode',
              WalletExceptionCode.recipientNotFound,
            ),
      ],
    );
  });
}
