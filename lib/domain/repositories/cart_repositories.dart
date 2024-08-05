import 'package:either_dart/either.dart';

import '../../core/common/common_error.dart';
import '../entities/cart_model.dart';

abstract class CartRepositories {
  Future<Either<CommonError, CartModel>> getCartByUserId(String userId);
  Future<Either<CommonError, CartModel>> addToCart(
      CartModel carts, String userId);
  Future<Either<CommonError, String>> updateQuantityCart(
      String cartId, String productId, int quantity);
  Future<Either<CommonError, String>> deleteCartById(
      String cartId, String productId);
}
