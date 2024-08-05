import 'package:either_dart/either.dart';

import '../../../core/common/common_error.dart';
import '../../entities/cart_model.dart';
import '../../repositories/cart_repositories.dart';

class GetCartByUserIdUsecase {
  final CartRepositories _repository;
  GetCartByUserIdUsecase(this._repository);

  Future<Either<CommonError, CartModel>> execute(String userId) {
    return _repository.getCartByUserId(userId).mapRight((right) => right);
  }
}
