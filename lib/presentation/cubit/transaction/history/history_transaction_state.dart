part of 'history_transaction_cubit.dart';

sealed class HistoryTransactionState extends Equatable {
  const HistoryTransactionState();

  @override
  List<Object> get props => [];
}

final class HistoryInitial extends HistoryTransactionState {}

final class HistoryLoading extends HistoryTransactionState {}

final class HistoryLoaded extends HistoryTransactionState {
  final List<PaymentModel> historyTransaction;

  const HistoryLoaded(this.historyTransaction);

  @override
  List<Object> get props => [historyTransaction];
}

final class HistoryError extends HistoryTransactionState {
  final String message;

  const HistoryError(this.message);

  @override
  List<Object> get props => [message];
}
