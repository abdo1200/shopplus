import 'package:shopplus/core/di/service_locator.dart';
import 'package:shopplus/features/wallet/data/repositories/mock_wallet_repository.dart';
import 'package:shopplus/features/wallet/domain/repositories/wallet_repository.dart';
import 'package:shopplus/features/wallet/domain/usecases/get_wallet_balance_usecase.dart';
import 'package:shopplus/features/wallet/domain/usecases/get_wallet_transactions_usecase.dart';
import 'package:shopplus/features/wallet/domain/usecases/transfer_points_usecase.dart';
import 'package:shopplus/features/wallet/presentation/transfer/bloc/transfer_points_bloc.dart';
import 'package:shopplus/features/wallet/presentation/wallet/bloc/wallet_bloc.dart';

void registerWalletDependencies() {
  if (!sl.isRegistered<WalletRepository>()) {
    sl.registerLazySingleton<WalletRepository>(MockWalletRepository.new);
  }

  if (!sl.isRegistered<GetWalletBalanceUseCase>()) {
    sl.registerLazySingleton<GetWalletBalanceUseCase>(
      () => GetWalletBalanceUseCase(sl()),
    );
  }

  if (!sl.isRegistered<GetWalletTransactionsUseCase>()) {
    sl.registerLazySingleton<GetWalletTransactionsUseCase>(
      () => GetWalletTransactionsUseCase(sl()),
    );
  }

  if (!sl.isRegistered<TransferPointsUseCase>()) {
    sl.registerLazySingleton<TransferPointsUseCase>(
      () => TransferPointsUseCase(sl()),
    );
  }

  if (!sl.isRegistered<WalletBloc>()) {
    sl.registerFactory<WalletBloc>(
      () => WalletBloc(getBalance: sl(), getTransactions: sl()),
    );
  }

  if (!sl.isRegistered<TransferPointsBloc>()) {
    sl.registerFactoryParam<TransferPointsBloc, int, void>(
      (availableBalance, _) => TransferPointsBloc(
        transferPoints: sl(),
        availableBalance: availableBalance,
      ),
    );
  }
}
