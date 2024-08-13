import 'package:cloud_firestore/cloud_firestore.dart';

import '../../core/common/enum/common_status_transaction.dart';
import 'product_model.dart';
import 'user_model.dart';

class PaymentModel {
  final UserModel user;
  final List<ProductCheckout> listProducts;
  final double totalPrice;
  final String? transactionId;
  final String? paymentMethod;
  final DateTime? createdAt;
  final CommonStatusTransaction? status;

  PaymentModel({
    required this.user,
    required this.listProducts,
    required this.totalPrice,
    this.paymentMethod,
    this.transactionId,
    this.createdAt,
    this.status,
  });

  PaymentModel copyWith({
    UserModel? user,
    String? paymentMethod,
    List<ProductCheckout>? listProducts,
    double? totalPrice,
    String? transactionId,
    DateTime? createdAt,
    CommonStatusTransaction? status,
  }) {
    return PaymentModel(
      user: user ?? this.user,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      listProducts: listProducts ?? this.listProducts,
      totalPrice: totalPrice ?? this.totalPrice,
      transactionId: transactionId ?? this.transactionId,
      createdAt: createdAt ?? this.createdAt,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'user': user.toMap(),
      'listProducts': listProducts.map((x) => x.toMap()).toList(),
      'totalPrice': totalPrice,
      'paymentMethod': paymentMethod,
      'transactionId': transactionId,
      'createdAt': createdAt ?? DateTime.now(),
      'status': 'success',
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
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      status: _getStatusEnum(map['status']),
    );
  }
}

CommonStatusTransaction _getStatusEnum(String? status) {
  switch (status) {
    case 'success':
      return CommonStatusTransaction.success;
    case 'failed':
      return CommonStatusTransaction.failed;
    case 'pending':
      return CommonStatusTransaction.pending;
    default:
      return CommonStatusTransaction.failed; // or any other default value
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
