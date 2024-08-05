import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:finalproject_flashora/presentation/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/common/utils/currency_helper.dart';
import '../../../../domain/entities/payment_model.dart';
import '../../../pages/transaction/payment/payment_method/cash_method.dart';
import '../../../pages/transaction/payment/payment_method/qris_method.dart';
import '../../../pages/transaction/payment/payment_method/transfer_method.dart';
import '../../product_cubit/product/product_cubit.dart';

part 'payment_state.dart';

class PaymentCubit extends Cubit<PaymentState> {
  PaymentCubit() : super(const PaymentLoaded());

  final List<Category> _paymentType = [
    Category(name: 'Cash', selected: true),
    Category(name: 'Transfer', selected: false),
    Category(name: 'QRIS', selected: false),
  ];
  List<Category> get paymentType => _paymentType;

  final List<Price> _staticPrice = [
    Price(price: 50000, isSelected: false),
    Price(price: 100000, isSelected: false),
    Price(price: 200000, isSelected: false),
    Price(price: 500000, isSelected: false),
    Price(price: 1000000, isSelected: false),
  ];
  List<Price> get staticPrice => _staticPrice;

  final List<PaymentMethod> paymentMethod = [
    PaymentMethod('BCA', 'assets/images/bca.png', false),
    PaymentMethod('BNI', 'assets/images/bni.png', false),
    PaymentMethod('BRI', 'assets/images/bri.png', false),
    PaymentMethod('MANDIRI', 'assets/images/mandiri.png', false),
    PaymentMethod('SHOPEE PAY', 'assets/images/shopeepay.jpg', false),
    PaymentMethod('GOPAY', 'assets/images/gopay.jpg', false),
    PaymentMethod('OVO', 'assets/images/ovo.png', false),
    PaymentMethod('LINK AJA', 'assets/images/linkaja.png', false),
    PaymentMethod('DANA', 'assets/images/dana.jpg', false),
  ];
  String _selectedPaymentMethod = '';
  String get selectedPaymentMethod => _selectedPaymentMethod;

  final formKey = GlobalKey<FormState>();

  final _paidAmountController = TextEditingController(text: 0.toString());
  TextEditingController get paidAmountController => _paidAmountController;

  final paidAmountFocus = FocusNode();

  List<Widget> listMethod = const [
    CashMethod(),
    TransferMethod(),
    QrisMethod(),
  ];

  void selectPrice(int index) {
    for (int i = 0; i < _staticPrice.length; i++) {
      _staticPrice[i] =
          _staticPrice[i].copyWith(isSelected: i == index ? true : false);
    }
    _paidAmountController.text = CurrencyHelper.thousandFormatCurrency(
        _staticPrice[index].price.toString());
  }

  void selectPayment(int index) {
    for (int i = 0; i < _paymentType.length; i++) {
      _paymentType[i] =
          _paymentType[i].copyWith(selected: i == index ? true : false);
    }

    emit(PaymentLoaded(indexTabbar: index, paymentMethod: paymentMethod));
  }

  void selectPaymentMethod(PaymentMethod item) {
    final newPaymentMethod = paymentMethod
        .map((e) => e.name == item.name
            ? item.copyWith(isSelected: true)
            : e.copyWith(isSelected: false))
        .toList();

    _selectedPaymentMethod = item.name;
    emit(PaymentLoaded(indexTabbar: 1, paymentMethod: newPaymentMethod));
  }

  void createTransaction(
      PaymentModel payment, int indexTabbar, BuildContext context) {
    String newSelectedPaymentMethod = indexTabbar == 0
        ? 'Cash'
        : indexTabbar == 1
            ? _selectedPaymentMethod
            : 'QRIS';

    PaymentModel paymentModel = PaymentModel(
      user: payment.user,
      listProducts: payment.listProducts,
      totalPrice: payment.totalPrice,
      paymentMethod: newSelectedPaymentMethod,
      transactionId:
          "ORD${DateFormat('ddMMyyyy').format(DateTime.now())}${Random().nextInt(1000)}",
    );

    router.pushNamed(RoutesName.historyTransactionDetail, extra: paymentModel);
  }

  @override
  Future<void> close() {
    paidAmountController.dispose();
    paidAmountFocus.dispose();

    return super.close();
  }
}

class Price {
  final int price;
  final bool isSelected;

  Price({required this.price, required this.isSelected});

  Price copyWith({int? price, bool? isSelected}) {
    return Price(
      price: price ?? this.price,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}

class PaymentMethod {
  final String name;
  final String assetsImage;
  final bool isSelected;

  PaymentMethod(this.name, this.assetsImage, this.isSelected);

  PaymentMethod copyWith(
      {String? name, String? assetsImage, bool? isSelected, String? method}) {
    return PaymentMethod(
      name ?? this.name,
      assetsImage ?? this.assetsImage,
      isSelected ?? this.isSelected,
    );
  }
}
