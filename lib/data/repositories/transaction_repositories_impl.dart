import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:either_dart/either.dart';

import '../../core/common/common_error.dart';
import '../../domain/entities/payment_model.dart';
import '../../domain/repositories/transaction_repositories.dart';
import '../datasources/transaction_datasource.dart';

class TransactionRepositoriesImpl implements TransactionRepositories {
  final TransactionDatasource dataSource;

  TransactionRepositoriesImpl({required this.dataSource});

  @override
  Future<Either<CommonError, PaymentModel>> createTransaction(
      PaymentModel payment) async {
    try {
      final response = await dataSource.createTransaction(payment);

      DocumentSnapshot<Map<String, dynamic>> result = await response.get();

      if (result.exists) {
        return Right(PaymentModel.fromMap(result.data()!));
      } else {
        return Left(CommonError(message: 'Failed to create transaction data'));
      }
    } catch (e) {
      return Left(CommonError(message: 'Unknown error: $e'));
    }
  }
}
