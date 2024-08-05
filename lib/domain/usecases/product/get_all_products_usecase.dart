import 'package:either_dart/either.dart';

import '../../../core/common/common_error.dart';
import '../../entities/product_model.dart';
import '../../repositories/product_repositories.dart';

class GetAllProductsUsecase {
  final ProductRepositories _repository;
  GetAllProductsUsecase(this._repository);

  Future<Either<CommonError, List<ProductModel>>> execute() {
    return _repository.getAllProducts().mapRight((right) =>
        List<ProductModel>.from(right.map((e) => e.convertToLocal())));
  }
}
