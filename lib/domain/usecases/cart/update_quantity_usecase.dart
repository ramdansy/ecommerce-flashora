import 'package:either_dart/either.dart';

import '../../../core/common/common_error.dart';
import '../../repositories/cart_repositories.dart';

class UpdateQuantityUsecase {
  final CartRepositories _repository;
  UpdateQuantityUsecase(this._repository);

  Future<Either<CommonError, String>> execute(
      String cartId, String productId, int quantity) {
    return _repository.updateQuantityCart(cartId, productId, quantity);
  }
}
