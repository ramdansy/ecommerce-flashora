import 'package:either_dart/either.dart';

import '../../core/common/common_error.dart';
import '../../domain/entities/cart_model.dart';
import '../../domain/repositories/cart_repositories.dart';
import '../datasources/cart_datasource.dart';

class CartRepositoriesImpl implements CartRepositories {
  final CartDatasource dataSource;

  CartRepositoriesImpl({required this.dataSource});

  @override
  Future<Either<CommonError, CartModel>> getCartByUserId(String userId) async {
    try {
      final response = await dataSource.getCartByUserId(userId);

      if (response.docs.isNotEmpty) {
        return Right(CartModel.fromMap(response.docs.first.data())
            .copyWith(id: response.docs.first.id));
      } else {
        return Right(CartModel(id: "", userId: userId, productCart: []));
      }
    } catch (e) {
      return Left(CommonError(message: 'Unknown error: $e'));
    }
  }

  @override
  Future<Either<CommonError, CartModel>> addToCart(
      CartModel carts, String userId) async {
    try {
      final cart = await getCartByUserId(userId);

      if (cart.right.userId == userId) {
        if (cart.right.productCart.isNotEmpty) {
          final existingProduct = cart.right.productCart
              .where((element) =>
                  element.productId == carts.productCart[0].productId)
              .toList();

          if (existingProduct.isNotEmpty) {
            final productCart = existingProduct.first;

            if (productCart.productId == carts.productCart[0].productId) {
              final update = await updateQuantityCart(
                cart.right.id,
                carts.productCart[0].productId,
                productCart.quantity + carts.productCart[0].quantity,
              );

              if (update.isRight) {
                return Right(CartModel(
                    id: cart.right.id,
                    userId: userId,
                    productCart: [productCart]));
              } else {
                return Left(CommonError(message: 'Failed to update quantity'));
              }
            }
          } else {
            await dataSource.addProductToExistingCart(
                cart.right.id, carts.productCart[0]);
            return Right(CartModel(
                id: cart.right.id,
                userId: userId,
                productCart: cart.right.productCart
                    .where((element) =>
                        element.productId != carts.productCart[0].productId)
                    .toList()));
          }
        } else {
          await dataSource.addProductToExistingCart(
            cart.right.id,
            carts.productCart[0],
          );
          return Right(CartModel(
              id: cart.right.id,
              userId: userId,
              productCart: cart.right.productCart
                  .where((element) =>
                      element.productId != carts.productCart[0].productId)
                  .toList()));
        }
      }

      final response = await dataSource.addToCart(carts);
      final result = await response.get();

      if (result.exists) {
        return Right(CartModel.fromMap(result.data()!));
      } else {
        return Left(CommonError(message: 'Failed to create carts data'));
      }
    } catch (e) {
      return Left(CommonError(message: 'Unknown error: $e'));
    }
  }

  @override
  Future<Either<CommonError, String>> updateQuantityCart(
      String cartId, String productId, int quantity) async {
    try {
      await dataSource.updateQuantityCart(cartId, productId, quantity);
      return const Right('Success updated quantity');
    } catch (e) {
      return Left(CommonError(message: 'Failed to update quantity: $e'));
    }
  }

  @override
  Future<Either<CommonError, String>> deleteCartById(
      String cartId, String productId) async {
    try {
      await dataSource.deleteCartById(cartId, productId);
      return const Right('Success deleted cart');
    } catch (e) {
      return Left(CommonError(message: 'Failed to delete cart: $e'));
    }
  }
}
