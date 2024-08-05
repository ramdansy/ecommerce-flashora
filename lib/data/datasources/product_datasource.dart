import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

import '../../../../core/app_constant.dart';

abstract class ProductDatasource {
  Future<QuerySnapshot<Map<String, dynamic>>> getAllProducts();
  Future<http.Response> getProductById(int productId);
}

class ProductDatasourceImpl implements ProductDatasource {
  final http.Client client;
  ProductDatasourceImpl({required this.client});

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<QuerySnapshot<Map<String, dynamic>>> getAllProducts() async {
    return await _firestore.collection(AppConstant.collectionProducts).get();
  }

  @override
  Future<http.Response> getProductById(int productId) async {
    return await http
        .get(Uri.parse('${AppConstant.baseUrl}/products/$productId'));
  }
}
