import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:either_dart/either.dart';

import '../../core/app_preferences.dart';
import '../../core/common/common_error.dart';
import '../../domain/entities/payment_model.dart';
import '../../domain/repositories/transaction_repositories.dart';
import '../datasources/cart_datasource.dart';
import '../datasources/transaction_datasource.dart';

class TransactionRepositoriesImpl implements TransactionRepositories {
  final TransactionDatasource dataSource;
  final CartDatasource cartDatasource;

  TransactionRepositoriesImpl(
      {required this.dataSource, required this.cartDatasource});

  @override
  Future<Either<CommonError, PaymentModel>> createTransaction(
      PaymentModel payment) async {
    try {
      final response = await dataSource.createTransaction(payment);

      DocumentSnapshot<Map<String, dynamic>> result = await response.get();

      if (result.exists) {
        final userId = await AppPreferences.getUserId();
        final resGetCart = await cartDatasource.getCartByUserId(userId!);
        await cartDatasource.deleteAllItemCart(resGetCart.docs.first.id);

        return Right(PaymentModel.fromMap(result.data()!));
      } else {
        return Left(CommonError(message: 'Failed to create transaction data'));
      }
    } catch (e) {
      return Left(CommonError(message: 'Unknown error: $e'));
    }
  }

  @override
  Future<Either<CommonError, List<PaymentModel>>> getAllTransaction() async {
    try {
      final response = await dataSource.getAllTransaction();

      if (response.docs.isNotEmpty) {
        final jsonResponse =
            response.docs.map((e) => PaymentModel.fromMap(e.data())).toList();
        return Right(List<PaymentModel>.from(jsonResponse));
      } else {
        return const Right([]);
      }
    } catch (e) {
      return Left(CommonError(message: 'Unknown error: $e'));
    }
  }

  @override
  Future<Either<CommonError, List<PaymentModel>>> filterTransaction(
      {required DateTime? startDate,
      required DateTime? endDate,
      double? minPrice,
      double? maxPrice,
      String? category,
      String? status}) async {
    try {
      final response = await dataSource.filterTransaction(
          startDate: startDate,
          endDate: endDate,
          minPrice: minPrice,
          maxPrice: maxPrice,
          category: category,
          status: status);
      if (response.docs.isNotEmpty) {
        final jsonResponse =
            response.docs.map((e) => PaymentModel.fromMap(e.data())).toList();
        return Right(List<PaymentModel>.from(jsonResponse));
      } else {
        return const Right([]);
      }
    } catch (e) {
      return Left(CommonError(message: 'Unknown error: $e'));
    }
  }
}
