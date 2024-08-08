import 'package:either_dart/either.dart';

import '../../../core/common/common_error.dart';
import '../../entities/product_model.dart';
import '../../repositories/product_repositories.dart';

class GetProductByIdUsecase {
  final ProductRepositories repositories;
  GetProductByIdUsecase(this.repositories);

  Future<Either<CommonError, ProductModel>> execute(String productId) async {
    return await repositories.getProductbyId(productId);
  }
}
