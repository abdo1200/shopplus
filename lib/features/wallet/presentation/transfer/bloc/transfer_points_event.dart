import 'package:equatable/equatable.dart';

sealed class TransferPointsEvent extends Equatable {
  const TransferPointsEvent();

  @override
  List<Object?> get props => [];
}

final class TransferRecipientChanged extends TransferPointsEvent {
  const TransferRecipientChanged(this.value);

  final String value;

  @override
  List<Object?> get props => [value];
}

final class TransferPointsChanged extends TransferPointsEvent {
  const TransferPointsChanged(this.value);

  final String value;

  @override
  List<Object?> get props => [value];
}

final class TransferNoteChanged extends TransferPointsEvent {
  const TransferNoteChanged(this.value);

  final String value;

  @override
  List<Object?> get props => [value];
}

final class TransferSubmitted extends TransferPointsEvent {
  const TransferSubmitted();
}

final class TransferEffectHandled extends TransferPointsEvent {
  const TransferEffectHandled();
}
