import '../../entities/product_model.dart';
import '../../repositories/product_repositories.dart';

class GetProductByIdUsecase {
  final ProductRepositories _repository;
  GetProductByIdUsecase(this._repository);

  Future<ProductModel> execute(int productId) {
    return _repository
        .getProductById(productId)
        .then((value) => value.convertToLocal());
  }
}
