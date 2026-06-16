import 'package:equatable/equatable.dart';

final class TransferRequestParams extends Equatable {
  const TransferRequestParams({
    required this.recipient,
    required this.points,
    this.note,
  });

  final String recipient;
  final int points;
  final String? note;

  @override
  List<Object?> get props => [recipient, points, note];
}
