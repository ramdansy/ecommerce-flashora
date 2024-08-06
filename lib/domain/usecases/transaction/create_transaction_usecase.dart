import 'package:either_dart/either.dart';

import '../../../core/common/common_error.dart';
import '../../entities/payment_model.dart';
import '../../repositories/transaction_repositories.dart';

class CreateTransactionUsecase {
  final TransactionRepositories _repository;

  CreateTransactionUsecase(this._repository);

  Future<Either<CommonError, PaymentModel>> execute(PaymentModel payment) {
    return _repository.createTransaction(payment);
  }
}
