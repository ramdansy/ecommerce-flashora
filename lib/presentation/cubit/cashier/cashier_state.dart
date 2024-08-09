part of 'cashier_cubit.dart';

sealed class CashierState extends Equatable {
  const CashierState();

  @override
  List<Object> get props => [];
}

final class CashierInitial extends CashierState {}

final class CashierLoading extends CashierState {}

final class UpdatingCashier extends CashierState {}

final class CashierLoaded extends CashierState {
  final List<ProductModel> products;
  final List<Category> categories;
  final CartModel? cart;

  const CashierLoaded(this.products, this.categories, this.cart);

  @override
  List<Object> get props => [
        products,
        categories,
      ];

  CashierLoaded copyWith({
    List<ProductModel>? products,
    List<Category>? categories,
    CartModel? cart,
  }) {
    return CashierLoaded(
      products ?? this.products,
      categories ?? this.categories,
      cart ?? this.cart,
    );
  }
}

final class CashierError extends CashierState {
  final String message;

  const CashierError(this.message);

  @override
  List<Object> get props => [message];
}
