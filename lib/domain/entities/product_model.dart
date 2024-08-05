import '../../data/models/response/product_response.dart';

class ProductModel {
  String id;
  String title;
  double price;
  String description;
  String category;
  List<String> image;
  double rating;
  int ratingCount;

  ProductModel({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.image,
    required this.rating,
    required this.ratingCount,
  });

  ProductModel copyWith({
    String? id,
    String? title,
    double? price,
    String? description,
    String? category,
    List<String>? image,
    double? rating,
    int? ratingCount,
  }) {
    return ProductModel(
      id: id ?? this.id,
      title: title ?? this.title,
      price: price ?? this.price,
      description: description ?? this.description,
      category: category ?? this.category,
      image: image ?? this.image,
      rating: rating ?? this.rating,
      ratingCount: ratingCount ?? this.ratingCount,
    );
  }

  Map<String, dynamic> toMap() => {
        "id": id,
        "title": title,
        "price": price,
        "description": description,
        "category": category,
        "image": List<String>.from(image.map((x) => x)),
        "rating": rating,
        "ratingCount": ratingCount,
      };

  factory ProductModel.fromMap(Map<String, dynamic> map) => ProductModel(
        id: map['id'],
        title: map['title'],
        price: map['price'],
        description: map['description'],
        category: map['category'],
        image: List<String>.from(map['image']),
        rating: map['rating'],
        ratingCount: map['ratingCount'],
      );
}

extension ProductModelExtension on ProductResponse {
  ProductModel convertToLocal() => ProductModel(
        id: id,
        title: title,
        price: price,
        description: description,
        category: category,
        image: image,
        rating: rating,
        ratingCount: ratingCount,
      );
}
