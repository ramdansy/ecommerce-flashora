import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/app_preferences.dart';
import '../../../../domain/entities/cart_model.dart';
import '../../../../domain/entities/product_model.dart';
import '../../../../domain/usecases/cart/add_cart_usecase.dart';
import '../../../../domain/usecases/product/get_product_by_id_usecase.dart';

part 'product_detail_state.dart';

class ProductDetailCubit extends Cubit<ProductDetailState> {
  final GetProductByIdUsecase getProductByIdUsecase;
  final AddCartUsecase _addCartUsecase;

  ProductDetailCubit(this._addCartUsecase, this.getProductByIdUsecase)
      : super(ProductDetailInitial());

  ProductModel? product;

  void addCart(CartModel cart) async {
    emit(LoadingAddTocart());

    cart.userId = (await AppPreferences.getUserId())!;
    final res = await _addCartUsecase.execute(cart, cart.userId);
    res.fold(
      (left) => emit(ProductDetailError(left.message.toString())),
      (right) => emit(SuccessAddTocart()),
    );
  }

  void getProduct(String productId) {
    emit(ProductDetailLoading());

    Future.delayed(const Duration(seconds: 1), () async {
      final res = await getProductByIdUsecase.execute(productId);
      res.fold(
        (left) => emit(ProductDetailError(left.message.toString())),
        (right) {
          product = right;
          emit(ProductDetailLoaded(right));
        },
      );
    });
  }
}
