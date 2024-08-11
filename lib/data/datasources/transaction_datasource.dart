import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/app_preferences.dart';

import '../../core/app_constant.dart';
import '../../domain/entities/payment_model.dart';

abstract class TransactionDatasource {
  Future<DocumentReference<Map<String, dynamic>>> createTransaction(
      PaymentModel payment);
  Future<QuerySnapshot<Map<String, dynamic>>> getAllTransaction();
  Future<QuerySnapshot<Map<String, dynamic>>> filterTransaction(
      {required DateTime? startDate,
      required DateTime? endDate,
      double? minPrice,
      double? maxPrice,
      String? category,
      String? status});
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

  @override
  Future<QuerySnapshot<Map<String, dynamic>>> getAllTransaction() async {
    final userId = await AppPreferences.getUserId();
    return await _firestore
        .collection(AppConstant.collectionTransaction)
        .where('user.id', isEqualTo: userId)
        .get();
  }

  @override
  Future<QuerySnapshot<Map<String, dynamic>>> filterTransaction({
    required DateTime? startDate,
    required DateTime? endDate,
    double? minPrice,
    double? maxPrice,
    String? category,
    String? status,
  }) async {
    final userId = await AppPreferences.getUserId();

    // Create a base query for the transaction collection
    final baseQuery = _firestore
        .collection(AppConstant.collectionTransaction)
        .where('user.id', isEqualTo: userId);

    // Build the final query with optional filters
    Query<Map<String, dynamic>> query = startDate != null && endDate != null
        ? baseQuery
            .where('date', isGreaterThanOrEqualTo: startDate)
            .where('date', isLessThanOrEqualTo: endDate)
        : baseQuery; // No date filter applied

    query = minPrice != null && maxPrice != null
        ? query
            .where('amount', isGreaterThanOrEqualTo: minPrice)
            .where('amount', isLessThanOrEqualTo: maxPrice)
        : query; // No price filter applied

    query =
        category != null ? query.where('category', isEqualTo: category) : query;
    query = status != null ? query.where('status', isEqualTo: status) : query;

    return await query.get();
  }
}
