import 'package:either_dart/either.dart';

import '../../../core/common/common_error.dart';
import '../../entities/product_model.dart';
import '../../repositories/product_repositories.dart';

class AddProductUsecase {
  final ProductRepositories _repository;
  AddProductUsecase(this._repository);

  Future<Either<CommonError, ProductModel>> execute(ProductModel product) {
    return _repository.addProduct(product);
  }
}
