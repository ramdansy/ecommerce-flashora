import 'dart:convert';

import 'package:either_dart/either.dart';

import '../../core/common/common_error.dart';
import '../../domain/repositories/product_repositories.dart';
import '../datasources/product_datasource.dart';
import '../models/response/product_response.dart';

class ProductRepositoriesImpl implements ProductRepositories {
  final ProductDatasource dataSource;

  ProductRepositoriesImpl({required this.dataSource});

  @override
  Future<ProductResponse> getProductById(int productId) async {
    try {
      final response = await dataSource.getProductById(productId);

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        return ProductResponse.fromMap(jsonResponse);
      } else {
        throw Exception('Failed to load product');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

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
}
