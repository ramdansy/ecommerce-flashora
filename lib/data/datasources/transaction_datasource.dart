import 'package:cloud_firestore/cloud_firestore.dart';

import '../../core/app_constant.dart';
import '../../domain/entities/payment_model.dart';

abstract class TransactionDatasource {
  Future<DocumentReference<Map<String, dynamic>>> createTransaction(
      PaymentModel payment);
}

class TransactionDatasourceImpl implements TransactionDatasource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<DocumentReference<Map<String, dynamic>>> createTransaction(
      PaymentModel payment) async {
    return await _firestore
        .collection(AppConstant.collectionTransaction)
        .add(payment.toMap());
  }
}
