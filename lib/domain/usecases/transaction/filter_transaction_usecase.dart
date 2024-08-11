import 'package:either_dart/either.dart';

import '../../../core/common/common_error.dart';
import '../../entities/payment_model.dart';
import '../../repositories/transaction_repositories.dart';

class FilterTransactionUsecase {
  final TransactionRepositories _repository;

  FilterTransactionUsecase(this._repository);

  Future<Either<CommonError, List<PaymentModel>>> execute(
      {required DateTime? startDate,
      required DateTime? endDate,
      double? minPrice,
      double? maxPrice,
      String? category,
      String? status}) {
    return _repository.filterTransaction(
        startDate: startDate,
        endDate: endDate,
        minPrice: minPrice,
        maxPrice: maxPrice,
        category: category,
        status: status);
  }
}
