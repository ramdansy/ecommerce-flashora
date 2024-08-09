import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/app_preferences.dart';
import '../../../domain/entities/cart_model.dart';
import '../../../domain/entities/product_model.dart';
import '../../../domain/usecases/cart/add_cart_usecase.dart';
import '../../../domain/usecases/cart/delete_cart_usecase.dart';
import '../../../domain/usecases/cart/get_cart_by_user_id_usecase.dart';
import '../../../domain/usecases/cart/update_quantity_usecase.dart';
import '../../../domain/usecases/product/get_all_products_usecase.dart';
import '../product_cubit/product/product_cubit.dart';

part 'cashier_state.dart';

class CashierCubit extends Cubit<CashierState> {
  final GetAllProductsUsecase getAllProducts;
  final AddCartUsecase addCartUsecase;
  final GetCartByUserIdUsecase getCartByUserIdUsecase;
  final UpdateQuantityUsecase updateQuantity;
  final DeleteCartUsecase deleteCartUsecase;

  CashierCubit(this.getAllProducts, this.addCartUsecase,
      this.getCartByUserIdUsecase, this.deleteCartUsecase, this.updateQuantity)
      : super(CashierInitial());

  List<ProductModel> listProduct = [];
  List<ProductModel> listFilterProduct = [];
  CartModel? _cart;

  List<Category> _listCategories = [];
  List<Category> listDefaultCategories = [
    Category(name: 'All', selected: true),
    Category(name: 'Shirt', selected: false),
    Category(name: 'Shoes', selected: false),
    Category(name: 'Pants', selected: false),
    Category(name: 'Accessories', selected: false),
    Category(name: 'Dress', selected: false),
    Category(name: 'Jacket', selected: false),
    Category(name: 'Hoodie', selected: false),
  ];
  List<Category> get listCategories => _listCategories;

  Future<void> fetchAllProducts() async {
    emit(CashierLoading());
    _listCategories = listDefaultCategories;

    final resProduct = await getAllProducts.execute();
    resProduct.fold(
      (left) => emit(CashierError(left.message.toString())),
      (right) {
        listProduct = right;
        listFilterProduct = right;
      },
    );

    final userId = await AppPreferences.getUserId();
    final responseCart = await getCartByUserIdUsecase.execute(userId!);
    responseCart.fold(
      (left) => emit(CashierError(left.message.toString())),
      (right) => _cart = right,
    );
    emit(CashierLoaded(listProduct, listCategories, _cart));
  }

  void filterProducts(Category categories) {
    emit(CashierLoading());

    final newCategories = listCategories
        .map((element) => element.name == categories.name
            ? element.copyWith(selected: true)
            : element.copyWith(selected: false))
        .toList();
    _listCategories = newCategories;

    List<ProductModel> newProducts = listProduct
        .where((element) =>
            element.category.toLowerCase() == categories.name.toLowerCase())
        .toList();

    listFilterProduct =
        categories.name.toLowerCase() == 'all' ? listProduct : newProducts;

    emit(CashierLoaded(listFilterProduct, newCategories, _cart));
  }

  void addProductToCart(BuildContext context, CartModel cart) async {
    emit(UpdatingCashier());

    cart.userId = (await AppPreferences.getUserId())!;
    final res = await addCartUsecase.execute(cart, cart.userId);
    res.fold(
      (left) => emit(CashierError(left.message.toString())),
      (right) {
        _cart!.productCart.addAll(cart.productCart);
      },
    );
    emit(CashierLoaded(listFilterProduct, listCategories, _cart));
  }

  void deleteItemFromCart(String cartId, String productId) async {
    if (_cart != null) {
      emit(UpdatingCashier());
      bool isDeleted = false;

      final resDeleteCart = await deleteCartUsecase.execute(cartId, productId);
      resDeleteCart.fold(
        (left) {},
        (right) => isDeleted = true,
      );

      if (isDeleted) {
        final newCart = _cart!.copyWith(
          productCart: _cart!.productCart
              .where((e) => e.productId != productId)
              .toList(),
        );

        _cart = newCart;
        emit(CashierLoaded(listFilterProduct, listCategories, _cart));
      }
    }
  }

  void incrementQuantity(String productId) async {
    if (_cart != null) {
      emit(UpdatingCashier());

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
          (left) => emit(CashierError(left.message.toString())),
          (right) {
            _cart = newCart;
            emit(CashierLoaded(listFilterProduct, listCategories, _cart));
          },
        );
      }
    }
  }

  void decrementQuantity(String productId) async {
    if (_cart != null) {
      emit(UpdatingCashier());

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
          (left) => emit(CashierError(left.message.toString())),
          (right) {
            _cart = newCart;
            emit(CashierLoaded(listFilterProduct, listCategories, _cart));
          },
        );
      }
    }
  }
}
