import 'package:equatable/equatable.dart';

import '../../../domain/entities/wallet_transaction_entity.dart';

sealed class WalletEvent extends Equatable {
  const WalletEvent();

  @override
  List<Object?> get props => [];
}

class WalletStarted extends WalletEvent {
  const WalletStarted();
}

class WalletRefreshed extends WalletEvent {
  const WalletRefreshed();
}

class WalletFilterChanged extends WalletEvent {
  const WalletFilterChanged(this.type);

  final WalletTransactionType? type;

  @override
  List<Object?> get props => [type];
}

class WalletNextPageRequested extends WalletEvent {
  const WalletNextPageRequested();
}
