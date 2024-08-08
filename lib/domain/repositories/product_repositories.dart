import 'package:either_dart/either.dart';

import '../../core/common/common_error.dart';
import '../../data/models/response/product_response.dart';
import '../entities/product_model.dart';

abstract class ProductRepositories {
  Future<Either<CommonError, List<ProductResponse>>> getAllProducts();
  Future<Either<CommonError, ProductModel>> addProduct(ProductModel product);
  Future<Either<CommonError, String>> deleteProduct(String productId);
  Future<Either<CommonError, String>> updateStock(
      String productId, int newStock);
  Future<Either<CommonError, String>> updatePrice(
      String productId, double newPrice);
  Future<Either<CommonError, ProductModel>> getProductbyId(String productId);
  Future<Either<CommonError, String>> updateProduct(ProductModel product);
}
