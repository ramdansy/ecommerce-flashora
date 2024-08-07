import 'package:either_dart/either.dart';

import '../../../core/common/common_error.dart';
import '../../repositories/product_repositories.dart';

class UpdatePriceUsecase {
  final ProductRepositories _repository;
  UpdatePriceUsecase(this._repository);

  Future<Either<CommonError, String>> execute(
      String productId, double newPrice) {
    return _repository.updatePrice(productId, newPrice);
  }
}
