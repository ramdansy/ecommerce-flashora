import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/entities/payment_model.dart';
import '../../../../domain/entities/user_model.dart';
import '../../../pages/transaction/checkout/checkout_screen.dart';
import '../../../routes/app_routes.dart';

part 'checkout_state.dart';

class CheckoutCubit extends Cubit<CheckoutState> {
  CheckoutCubit() : super(CheckoutInitial());

  void createOrder(UserModel user, List<ProductCheckout> listProducts) {
    PaymentModel paymentModel = PaymentModel(
      user: user,
      listProducts: listProducts,
      totalPrice: listProducts
          .map((e) => e.product.price * e.quantity)
          .reduce((value, element) => value + element),
    );

    router.pushNamed(RoutesName.payment, extra: paymentModel);
  }
}
