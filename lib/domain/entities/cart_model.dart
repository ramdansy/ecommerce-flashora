import 'product_model.dart';

import '../../data/models/response/cart_response.dart';

class CartModel {
  String id;
  String userId;
  List<ProductDetailCartModel> productCart;
  // double totalPrice;
  double get totalPrice => productCart
      .map((e) => e.product!.price * e.quantity)
      .reduce((a, b) => a + b);

  CartModel({
    required this.id,
    required this.userId,
    required this.productCart,
    // this.totalPrice = 0.0,
  });

  CartModel copyWith({
    String? id,
    String? userId,
    List<ProductDetailCartModel>? productCart,
    double? totalPrice,
  }) {
    return CartModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      productCart: productCart ?? this.productCart,
      // totalPrice: totalPrice ?? this.totalPrice,
    );
  }

  Map<String, dynamic> toMap() => {
        // "id": id,
        "userId": userId,
        "productCart": List<dynamic>.from(productCart.map((x) => x.toMap())),
        "totalPrice": totalPrice,
      };

  factory CartModel.fromMap(Map<String, dynamic> map) => CartModel(
        id: map["id"] ?? "",
        userId: map["userId"],
        productCart: List<ProductDetailCartModel>.from(
            map["productCart"].map((x) => ProductDetailCartModel.fromMap(x))),
        // totalPrice: map["totalPrice"] ?? 0.0,
      );
}

extension CartModelExtension on CartResponse {
  CartModel convertToLocal() => CartModel(
        id: id,
        userId: userId,
        productCart: List<ProductDetailCartModel>.from(
          products
              .map((x) => ProductDetailCartModel(
                    productId: x.productId,
                    quantity: x.quantity,
                    product: null,
                  ))
              .toList(),
        ),
      );
}

class ProductDetailCartModel {
  String productId;
  int quantity;
  ProductModel? product;

  ProductDetailCartModel({
    required this.productId,
    required this.quantity,
    this.product,
  });

  ProductDetailCartModel copyWith({
    String? productId,
    int? quantity,
    ProductModel? product,
  }) {
    return ProductDetailCartModel(
      productId: productId ?? this.productId,
      quantity: quantity ?? this.quantity,
      product: product ?? this.product,
    );
  }

  Map<String, dynamic> toMap() => {
        "productId": productId,
        "quantity": quantity,
        "product": product?.toMap(),
      };

  factory ProductDetailCartModel.fromMap(Map<String, dynamic> json) =>
      ProductDetailCartModel(
        productId: json["productId"],
        quantity: json["quantity"],
        product: json["product"] != null
            ? ProductModel.fromMap(json["product"])
            : null,
      );
}
