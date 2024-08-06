import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

import '../../../../core/app_constant.dart';
import '../../domain/entities/cart_model.dart';

abstract class CartDatasource {
  Future<QuerySnapshot<Map<String, dynamic>>> getCartByUserId(String userId);
  Future<DocumentReference<Map<String, dynamic>>> addToCart(CartModel carts);
  Future<void> updateQuantityCart(
      String cartId, String productId, int quantity);
  Future<void> addProductToExistingCart(
      String cartId, ProductDetailCartModel productDetailCartModel);
  Future<void> deleteCartById(String cartId, String productId);
  Future<void> deleteAllItemCart(String cartId);
}

class CartDatasourceImpl implements CartDatasource {
  final http.Client client;
  CartDatasourceImpl({required this.client});

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<QuerySnapshot<Map<String, dynamic>>> getCartByUserId(
      String userId) async {
    return await _firestore
        .collection(AppConstant.collectioncarts)
        .where('userId', isEqualTo: userId)
        .get();
  }

  @override
  Future<DocumentReference<Map<String, dynamic>>> addToCart(
      CartModel carts) async {
    return await _firestore
        .collection(AppConstant.collectioncarts)
        .add(carts.toMap());
  }

  @override
  Future<void> addProductToExistingCart(
      String cartId, ProductDetailCartModel productDetailCartModel) async {
    final cartRef =
        _firestore.collection(AppConstant.collectioncarts).doc(cartId);
    final selectedCart = await cartRef.get();

    if (selectedCart.exists) {
      final selectedProduct = selectedCart.get('productCart');
      selectedProduct.add(productDetailCartModel.toMap());
      await cartRef.update({'productCart': selectedProduct});
    }
  }

  @override
  Future<void> updateQuantityCart(
      String cartId, String productId, int quantity) async {
    final cartRef =
        _firestore.collection(AppConstant.collectioncarts).doc(cartId);
    final selectedCart = await cartRef.get();

    if (selectedCart.exists) {
      final selectedProduct = selectedCart.get('productCart');
      for (var element in selectedProduct) {
        if (element['productId'] == productId) {
          element['quantity'] = quantity;
          await cartRef.update({'productCart': selectedProduct});
          break;
        }
      }
    }
  }

  @override
  Future<void> deleteCartById(String cartId, String productId) async {
    final cartRef =
        _firestore.collection(AppConstant.collectioncarts).doc(cartId);
    final selectedCart = await cartRef.get();

    if (selectedCart.exists) {
      final selectedProduct = selectedCart.get('productCart');
      selectedProduct
          .removeWhere((element) => element['productId'] == productId);
      await cartRef.update({'productCart': selectedProduct});
    }
  }

  @override
  Future<void> deleteAllItemCart(String cartId) async {
    final cartRef =
        _firestore.collection(AppConstant.collectioncarts).doc(cartId);
    final selectedCart = await cartRef.get();

    if (selectedCart.exists) {
      await cartRef.update({'productCart': []});
    }
  }
}
