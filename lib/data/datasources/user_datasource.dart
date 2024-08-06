import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/app_constant.dart';
import '../../domain/entities/user_model.dart';

abstract class UserDatasource {
  Future<DocumentSnapshot<Map<String, dynamic>>> getUserId(String userId);
  Future<DocumentReference<Map<String, dynamic>>> createUser(UserModel user);
}

class UserDatasourceImpl implements UserDatasource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<DocumentSnapshot<Map<String, dynamic>>> getUserId(
      String userId) async {
    final res = await _firestore
        .collection(AppConstant.collectionUser)
        .where('id', isEqualTo: userId)
        .get();

    return res.docs.first;
  }

  @override
  Future<DocumentReference<Map<String, dynamic>>> createUser(
      UserModel user) async {
    return await _firestore
        .collection(AppConstant.collectionUser)
        .add(user.toMap());
  }
}
