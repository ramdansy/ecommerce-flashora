import 'package:either_dart/either.dart';

import '../../core/common/common_error.dart';
import '../../data/models/response/product_response.dart';

abstract class ProductRepositories {
  Future<Either<CommonError, List<ProductResponse>>> getAllProducts();
  Future<ProductResponse> getProductById(int productId);
}
