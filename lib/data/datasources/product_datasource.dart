import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/app_constant.dart';
import '../../domain/entities/product_model.dart';

abstract class ProductDatasource {
  Future<QuerySnapshot<Map<String, dynamic>>> getAllProducts();
  Future<DocumentReference<Map<String, dynamic>>> addProduct(
      ProductModel product);
  Future<void> deleteProduct(String productId);
  Future<void> updateStock(String productId, int newStock);
  Future<void> updatePrice(String productId, double newPrice);
}

class ProductDatasourceImpl implements ProductDatasource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<QuerySnapshot<Map<String, dynamic>>> getAllProducts() async {
    return await _firestore.collection(AppConstant.collectionProducts).get();
  }

  @override
  Future<DocumentReference<Map<String, dynamic>>> addProduct(
      ProductModel product) async {
    return await _firestore
        .collection(AppConstant.collectionProducts)
        .add(product.toMap());
  }

  @override
  Future<void> deleteProduct(String productId) async {
    return await _firestore
        .collection(AppConstant.collectionProducts)
        .doc(productId)
        .delete();
  }

  @override
  Future<void> updatePrice(String productId, double newPrice) async {
    return await _firestore
        .collection(AppConstant.collectionProducts)
        .doc(productId)
        .update({'price': newPrice});
  }

  @override
  Future<void> updateStock(String productId, int newStock) async {
    return await _firestore
        .collection(AppConstant.collectionProducts)
        .doc(productId)
        .update({'stock': newStock});
  }
}
