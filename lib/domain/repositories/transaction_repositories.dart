import 'package:either_dart/either.dart';

import '../../core/common/common_error.dart';
import '../entities/payment_model.dart';

abstract class TransactionRepositories {
  Future<Either<CommonError, PaymentModel>> createTransaction(
      PaymentModel payment);
  Future<Either<CommonError, List<PaymentModel>>> getAllTransaction();
  Future<Either<CommonError, List<PaymentModel>>> filterTransaction(
      {required DateTime? startDate,
      required DateTime? endDate,
      double? minPrice,
      double? maxPrice,
      String? category,
      String? status});
}
