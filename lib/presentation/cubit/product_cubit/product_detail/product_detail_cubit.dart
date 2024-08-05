import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/app_preferences.dart';
import '../../../../domain/entities/cart_model.dart';
import '../../../../domain/usecases/cart/add_cart_usecase.dart';

part 'product_detail_state.dart';

class ProductDetailCubit extends Cubit<ProductDetailState> {
  final AddCartUsecase _addCartUsecase;
  ProductDetailCubit(this._addCartUsecase) : super(ProductDetailInitial());

  void addCart(CartModel cart) async {
    emit(LoadingAddTocart());

    cart.userId = (await AppPreferences.getUserId())!;
    final res = await _addCartUsecase.execute(cart, cart.userId);
    res.fold(
      (left) => emit(ProductDetailError(left.message.toString())),
      (right) => emit(SuccessAddTocart()),
    );
  }
}
