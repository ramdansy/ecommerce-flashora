import 'package:either_dart/either.dart';

import '../../../core/common/common_error.dart';
import '../../entities/product_model.dart';
import '../../repositories/product_repositories.dart';

class UpdateProductUsecase {
  final ProductRepositories repositories;
  UpdateProductUsecase(this.repositories);

  Future<Either<CommonError, String>> execute(ProductModel product) async {
    return await repositories.updateProduct(product);
  }
}
