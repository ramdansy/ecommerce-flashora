import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/common/enum/common_status_transaction.dart';
import '../../../../domain/entities/payment_model.dart';
import '../../../../domain/usecases/transaction/get_all_transaction_usecase.dart';

part 'history_transaction_state.dart';

class HistoryTransactionCubit extends Cubit<HistoryTransactionState> {
  final GetAllTransactionUsecase getAllTransactionUsecase;
  HistoryTransactionCubit(this.getAllTransactionUsecase)
      : super(HistoryInitial());

  List<PaymentModel> _listPayment = [];

  void getHistoryTransaction() async {
    emit(HistoryLoading());

    _listPayment.clear();

    final response = await getAllTransactionUsecase.execute();
    response.fold(
      (left) => emit(HistoryError(left.message.toString())),
      (right) {
        _listPayment.addAll(right);
        emit(HistoryLoaded(_listPayment));
      },
    );
  }

  void filterList(int index) {
    emit(HistoryLoading());

    Future.delayed(const Duration(milliseconds: 500), () {
      if (index == 0) {
        emit(HistoryLoaded(_listPayment));
        return;
      }

      final status = index == 1
          ? CommonStatusTransaction.success
          : index == 2
              ? CommonStatusTransaction.pending
              : CommonStatusTransaction.failed;

      final filtered =
          _listPayment.where((element) => element.status == status).toList();
      emit(HistoryLoaded(filtered));
    });
  }
}
