import '../../presentation/pages/transaction/checkout/checkout_screen.dart';
import 'user_model.dart';

class PaymentModel {
  final UserModel user;
  final List<ProductCheckout> listProducts;
  final double totalPrice;
  final String? transactionId;
  final String? paymentMethod;

  PaymentModel({
    required this.user,
    required this.listProducts,
    required this.totalPrice,
    this.paymentMethod,
    this.transactionId,
  });

  PaymentModel copyWith({
    UserModel? user,
    String? paymentMethod,
    List<ProductCheckout>? listProducts,
    double? totalPrice,
    String? transactionId,
  }) {
    return PaymentModel(
      user: user ?? this.user,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      listProducts: listProducts ?? this.listProducts,
      totalPrice: totalPrice ?? this.totalPrice,
      transactionId: transactionId ?? this.transactionId,
    );
  }
}
