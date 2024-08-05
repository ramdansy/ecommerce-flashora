import 'dart:convert';

CartResponse cartModelFromMap(String str) =>
    CartResponse.fromMap(json.decode(str));

String cartModelToMap(CartResponse data) => json.encode(data.toMap());

class CartResponse {
  String id;
  String userId;
  DateTime date;
  List<ProductCart> products;

  CartResponse({
    required this.id,
    required this.userId,
    required this.date,
    required this.products,
  });

  factory CartResponse.fromMap(Map<String, dynamic> json) => CartResponse(
        id: json["id"],
        userId: json["userId"],
        date: DateTime.parse(json["date"]),
        products: List<ProductCart>.from(
            json["products"].map((x) => ProductCart.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "userId": userId,
        "date": date.toIso8601String(),
        "products": List<dynamic>.from(products.map((x) => x.toMap())),
      };
}

class ProductCart {
  String productId;
  int quantity;

  ProductCart({
    required this.productId,
    required this.quantity,
  });

  factory ProductCart.fromMap(Map<String, dynamic> json) => ProductCart(
        productId: json["productId"],
        quantity: json["quantity"],
      );

  Map<String, dynamic> toMap() => {
        "productId": productId,
        "quantity": quantity,
      };
}
