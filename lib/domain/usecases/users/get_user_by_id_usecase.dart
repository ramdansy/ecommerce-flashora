import 'package:either_dart/either.dart';

import '../../../core/common/common_error.dart';
import '../../entities/user_model.dart';
import '../../repositories/user_repositories.dart';

class GetUserIdUsecase {
  final UserRepositories _repository;
  GetUserIdUsecase(this._repository);

  Future<Either<CommonError, UserModel>> execute(String userId) {
    return _repository
        .getUserId(userId)
        .mapRight((right) => right.convertToLocal());
  }
}
