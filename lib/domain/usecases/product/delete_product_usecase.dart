import 'package:either_dart/either.dart';

import '../../../core/common/common_error.dart';
import '../../repositories/product_repositories.dart';

class DeleteProductUsecase {
  final ProductRepositories _repository;
  DeleteProductUsecase(this._repository);

  Future<Either<CommonError, String>> execute(String productId) {
    return _repository.deleteProduct(productId);
  }
}
