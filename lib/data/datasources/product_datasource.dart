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
  Future<DocumentSnapshot<Map<String, dynamic>>> getProductbyId(
      String productId);
  Future<void> updateProduct(ProductModel product);
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
  Future<void> updateStock(String productId, int newStock) {
    return _firestore
        .collection(AppConstant.collectionProducts)
        .doc(productId)
        .update({'stock': newStock});
  }

  @override
  Future<DocumentSnapshot<Map<String, dynamic>>> getProductbyId(
      String productId) {
    final productRef =
        _firestore.collection(AppConstant.collectionProducts).doc(productId);
    return productRef.get();
  }

  @override
  Future<void> updateProduct(ProductModel product) {
    final productRef =
        _firestore.collection(AppConstant.collectionProducts).doc(product.id);
    return productRef.update(product.toMap());
  }
}
