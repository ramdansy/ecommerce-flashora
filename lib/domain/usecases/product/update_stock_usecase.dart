import 'package:either_dart/either.dart';

import '../../../core/common/common_error.dart';
import '../../repositories/product_repositories.dart';

class UpdateStockUsecase {
  final ProductRepositories _repository;
  UpdateStockUsecase(this._repository);

  Future<Either<CommonError, String>> execute(String productId, int newStock) {
    return _repository.updateStock(productId, newStock);
  }
}
