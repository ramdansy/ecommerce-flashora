import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:either_dart/either.dart';

import '../../core/common/common_error.dart';
import '../../domain/entities/product_model.dart';
import '../../domain/repositories/product_repositories.dart';
import '../datasources/product_datasource.dart';
import '../models/response/product_response.dart';

class ProductRepositoriesImpl implements ProductRepositories {
  final ProductDatasource dataSource;

  ProductRepositoriesImpl({required this.dataSource});

  @override
  Future<Either<CommonError, List<ProductResponse>>> getAllProducts() async {
    try {
      final response = await dataSource.getAllProducts();

      if (response.docs.isNotEmpty) {
        final jsonResponse = response.docs
            .map((e) => ProductResponse.fromMap(e.data()).copyWith(id: e.id))
            .toList();
        return Right(List<ProductResponse>.from(jsonResponse));
      } else {
        return Left(CommonError(message: 'Failed to load products data'));
      }
    } catch (e) {
      return Left(CommonError(message: 'Unknown error: $e'));
    }
  }

  @override
  Future<Either<CommonError, ProductModel>> addProduct(
      ProductModel product) async {
    try {
      final response = await dataSource.addProduct(product);
      DocumentSnapshot<Map<String, dynamic>> result = await response.get();

      if (result.exists) {
        return Right(
            ProductModel.fromMap(result.data()!).copyWith(id: result.id));
      } else {
        return Left(CommonError(message: 'Failed to create product data'));
      }
    } catch (e) {
      return Left(CommonError(message: 'Unknown error: $e'));
    }
  }

  @override
  Future<Either<CommonError, String>> deleteProduct(String productId) async {
    try {
      await dataSource.deleteProduct(productId);
      return const Right('Success deleted product');
    } catch (e) {
      return Left(CommonError(message: 'Failed to delete product: $e'));
    }
  }

  @override
  Future<Either<CommonError, String>> updatePrice(
      String productId, double newPrice) async {
    try {
      await dataSource.updatePrice(productId, newPrice);
      return const Right('Success updated price');
    } catch (e) {
      return Left(CommonError(message: 'Failed to update price: $e'));
    }
  }

  @override
  Future<Either<CommonError, String>> updateStock(
      String productId, int newStock) async {
    try {
      await dataSource.updateStock(productId, newStock);
      return const Right('Success updated stock');
    } catch (e) {
      return Left(CommonError(message: 'Failed to update stock: $e'));
    }
  }
}
