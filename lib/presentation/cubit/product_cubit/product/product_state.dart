part of 'product_cubit.dart';

sealed class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object> get props => [];
}

final class ProductInitial extends ProductState {}

final class ProductLoading extends ProductState {}

final class ProductLoaded extends ProductState {
  final List<ProductModel> products;
  final List<Category> categories;

  const ProductLoaded(this.products, this.categories);

  @override
  List<Object> get props => [
        products,
      ];

  ProductLoaded copyWith({
    List<ProductModel>? products,
    List<Category>? categories,
  }) {
    return ProductLoaded(
      products ?? this.products,
      categories ?? this.categories,
    );
  }
}

final class ProductError extends ProductState {
  final String message;

  const ProductError(this.message);

  @override
  List<Object> get props => [message];
}
