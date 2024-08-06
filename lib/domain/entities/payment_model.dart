import 'product_model.dart';
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

  Map<String, dynamic> toMap() {
    return {
      'user': user.toMap(),
      'listProducts': listProducts.map((x) => x.toMap()).toList(),
      'totalPrice': totalPrice,
      'paymentMethod': paymentMethod,
      'transactionId': transactionId,
    };
  }

  factory PaymentModel.fromMap(Map<String, dynamic> map) {
    return PaymentModel(
      user: UserModel.fromMap(map['user']),
      listProducts: List<ProductCheckout>.from(
          map['listProducts']?.map((x) => ProductCheckout.fromMap(x))),
      totalPrice: map['totalPrice']?.toDouble() ?? 0.0,
      paymentMethod: map['paymentMethod'],
      transactionId: map['transactionId'],
    );
  }
}

class ProductCheckout {
  final ProductModel product;
  final int quantity;

  ProductCheckout({required this.product, required this.quantity});

  Map<String, dynamic> toMap() {
    return {
      'product': product.toMap(),
      'quantity': quantity,
    };
  }

  factory ProductCheckout.fromMap(Map<String, dynamic> map) {
    return ProductCheckout(
      product: ProductModel.fromMap(map['product']),
      quantity: map['quantity'],
    );
  }
}
