import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/app_preferences.dart';
import '../../../domain/entities/cart_model.dart';
import '../../../domain/entities/payment_model.dart';
import '../../../domain/usecases/cart/delete_cart_usecase.dart';
import '../../../domain/usecases/cart/get_cart_by_user_id_usecase.dart';
import '../../../domain/usecases/cart/update_quantity_usecase.dart';
import '../../routes/app_routes.dart';

part 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  final GetCartByUserIdUsecase getCartByUserId;
  final UpdateQuantityUsecase updateQuantity;
  final DeleteCartUsecase deleteCart;
  CartCubit(this.getCartByUserId, this.updateQuantity, this.deleteCart)
      : super(CartInitial());

  CartModel? _cart;

  void loadCart() async {
    emit(CartLoading());
    final userId = await AppPreferences.getUserId();

    final responseCart = await getCartByUserId.execute(userId!);
    responseCart.fold(
      (left) => emit(CartError(left.message.toString())),
      (right) {
        if (right.productCart.isNotEmpty) {
          _cart = right;
          emit(CartLoaded(_cart!));
        } else {
          emit(CartEmpty());
        }
      },
    );
  }

  void incrementQuantity(String productId) async {
    if (_cart != null) {
      final productIndex = _cart!.productCart
          .indexWhere((element) => element.productId == productId);

      if (productIndex != -1) {
        final newCart = _cart!.copyWith(
          productCart: _cart!.productCart.map((e) {
            if (e.productId == productId) {
              return e.copyWith(quantity: e.quantity + 1);
            } else {
              return e;
            }
          }).toList(),
        );

        final resUpdateQuantity = await updateQuantity.execute(
            _cart!.id, productId, newCart.productCart[productIndex].quantity);
        resUpdateQuantity.fold(
          (left) => emit(CartError(left.message.toString())),
          (right) {
            _cart = newCart;
            emit(CartLoaded(_cart!));
          },
        );
      }
    }
  }

  void decrementQuantity(String productId) async {
    if (_cart != null) {
      final productIndex = _cart!.productCart
          .indexWhere((element) => element.productId == productId);

      if (productIndex != -1) {
        final newCart = _cart!.copyWith(
          productCart: _cart!.productCart.map((e) {
            if (e.productId == productId) {
              return e.copyWith(quantity: e.quantity - 1);
            } else {
              return e;
            }
          }).toList(),
        );

        final resUpdateQuantity = await updateQuantity.execute(
            _cart!.id, productId, newCart.productCart[productIndex].quantity);
        resUpdateQuantity.fold(
          (left) => emit(CartError(left.message.toString())),
          (right) {
            _cart = newCart;
            emit(CartLoaded(_cart!));
          },
        );
      }
    }
  }

  void deleteItemFromCart(String cartId, String productId) async {
    if (_cart != null) {
      final resDeleteCart = await deleteCart.execute(cartId, productId);
      resDeleteCart.fold(
        (left) => emit(CartError(left.message.toString())),
        (right) => emit(CartLoaded(_cart!)),
      );

      final newCart = _cart!.copyWith(
        productCart:
            _cart!.productCart.where((e) => e.productId != productId).toList(),
      );

      if (newCart.productCart.isEmpty) {
        emit(CartEmpty());
      } else {
        _cart = newCart;
        emit(CartLoaded(_cart!));
      }
    }
  }

  void gotoCheckout() {
    if (_cart != null) {
      List<ProductCheckout> productsCheckout = [];

      for (ProductDetailCartModel element in _cart?.productCart ?? []) {
        productsCheckout.add(ProductCheckout(
          product: element.product!,
          quantity: element.quantity,
        ));
      }

      router.pushNamed(RoutesName.checkout, extra: productsCheckout);
    }
  }
}
