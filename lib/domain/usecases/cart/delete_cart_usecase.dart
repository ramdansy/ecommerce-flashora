import 'package:either_dart/either.dart';

import '../../../core/common/common_error.dart';
import '../../repositories/cart_repositories.dart';

class DeleteCartUsecase {
  final CartRepositories _repository;
  DeleteCartUsecase(this._repository);

  Future<Either<CommonError, String>> execute(String cartId, String productId) {
    return _repository.deleteCartById(cartId, productId);
  }
}
