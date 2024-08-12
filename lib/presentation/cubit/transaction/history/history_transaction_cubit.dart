import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
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
  final searchController = TextEditingController();

  Future<void> getHistoryTransaction() async {
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

  Future<void> onRefresh() {
    searchController.clear;
    return getHistoryTransaction();
  }

  void searchProducts(String value) {
    emit(HistoryLoading());

    Future.delayed(const Duration(milliseconds: 500), () {
      List<PaymentModel> newList = _listPayment
          .where((element) => element.listProducts.any(
                (product) => product.product.title
                    .toLowerCase()
                    .contains(value.toLowerCase()),
              ))
          .toList();

      emit(HistoryLoaded(newList));
    });
  }

  void filterHistory(BuildContext context,
      {String category = 'all',
      String status = 'all',
      DateTime? startDate,
      DateTime? endDate,
      double? minPrice,
      double? maxPrice}) {
    emit(HistoryLoading());
    List<PaymentModel> newList = _listPayment;

    Future.delayed(const Duration(milliseconds: 500), () {
      //category
      newList = category.toLowerCase() == 'all'
          ? _listPayment
          : _listPayment
              .where((payment) => payment.listProducts.any((product) =>
                  product.product.category.toLowerCase() ==
                  category.toLowerCase()))
              .toList();

      //status
      newList = status.toLowerCase() == 'all'
          ? newList
          : newList
              .where((payment) =>
                  payment.status!.toReadableString().toLowerCase() ==
                  status.toLowerCase())
              .toList();

      //date range
      newList = startDate == null && endDate == null
          ? newList
          : newList
              .where((payment) =>
                  payment.createdAt!.isAfter(startDate!) &&
                  payment.createdAt!.isBefore(endDate!))
              .toList();

      //price
      newList = minPrice == null && maxPrice == null
          ? newList
          : newList
              .where((payment) =>
                  payment.totalPrice >= minPrice! &&
                  payment.totalPrice <= maxPrice!)
              .toList();

      searchController.clear();
      emit(HistoryLoaded(newList));
      Navigator.of(context).pop();
    });
  }
}
