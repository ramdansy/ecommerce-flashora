import 'package:either_dart/either.dart';

import '../../../core/common/common_error.dart';
import '../../entities/cart_model.dart';
import '../../repositories/cart_repositories.dart';

class AddCartUsecase {
  final CartRepositories _repository;
  AddCartUsecase(this._repository);

  Future<Either<CommonError, CartModel>> execute(
      CartModel carts, String userId) {
    return _repository.addToCart(carts, userId);
  }
}
