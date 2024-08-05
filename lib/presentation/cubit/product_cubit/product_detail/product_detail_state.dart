part of 'product_detail_cubit.dart';

sealed class ProductDetailState extends Equatable {
  const ProductDetailState();

  @override
  List<Object> get props => [];
}

final class ProductDetailInitial extends ProductDetailState {}

final class LoadingAddTocart extends ProductDetailState {}

final class ProductDetailError extends ProductDetailState {
  final String message;
  const ProductDetailError(this.message);
}

final class SuccessAddTocart extends ProductDetailState {}
