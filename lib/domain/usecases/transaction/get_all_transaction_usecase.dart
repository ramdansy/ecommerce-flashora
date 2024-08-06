import 'package:either_dart/either.dart';

import '../../../core/common/common_error.dart';
import '../../entities/payment_model.dart';
import '../../repositories/transaction_repositories.dart';

class GetAllTransactionUsecase {
  final TransactionRepositories _repository;
  GetAllTransactionUsecase(this._repository);

  Future<Either<CommonError, List<PaymentModel>>> execute() {
    return _repository
        .getAllTransaction()
        .mapRight((right) => List<PaymentModel>.from(right));
  }
}
