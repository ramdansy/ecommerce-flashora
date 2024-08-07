import 'dart:convert';

ProductResponse productResponseFromMap(String str) =>
    ProductResponse.fromMap(json.decode(str));

String productResponseToMap(ProductResponse data) => json.encode(data.toMap());

class ProductResponse {
  String id;
  String title;
  double price;
  String description;
  String category;
  List<String> image;
  double rating;
  int ratingCount;
  int stock;

  ProductResponse({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.image,
    required this.rating,
    required this.ratingCount,
    required this.stock,
  });

  factory ProductResponse.fromMap(Map<String, dynamic> json) => ProductResponse(
        id: json["id"] ?? "",
        title: json["title"],
        price: json["price"].toDouble(),
        description: json["description"],
        category: json["category"],
        image: List<String>.from(json["image"].map((x) => x)),
        rating: json["rating"],
        ratingCount: json["ratingCount"],
        stock: json["stock"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "title": title,
        "price": price,
        "description": description,
        "category": category,
        "image": List<dynamic>.from(image.map((x) => x)),
        "rating": rating,
        "ratingCount": ratingCount,
        "stock": stock,
      };

  ProductResponse copyWith({
    String? id,
    String? title,
    double? price,
    String? description,
    String? category,
    List<String>? image,
    double? rating,
    int? ratingCount,
    int? stock,
  }) {
    return ProductResponse(
      id: id ?? this.id,
      title: title ?? this.title,
      price: price ?? this.price,
      description: description ?? this.description,
      category: category ?? this.category,
      image: image ?? this.image,
      rating: rating ?? this.rating,
      ratingCount: ratingCount ?? this.ratingCount,
      stock: stock ?? this.stock,
    );
  }
}

class Rating {
  double rate;
  int count;

  Rating({
    required this.rate,
    required this.count,
  });

  factory Rating.fromMap(Map<String, dynamic> json) => Rating(
        rate: json["rate"]?.toDouble(),
        count: json["count"],
      );

  Map<String, dynamic> toMap() => {
        "rate": rate,
        "count": count,
      };
}
