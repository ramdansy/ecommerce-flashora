import 'package:either_dart/either.dart';

import '../../../core/common/common_error.dart';
import '../../entities/user_model.dart';
import '../../repositories/user_repositories.dart';

class CreateUserUsecase {
  final UserRepositories _repository;

  CreateUserUsecase(this._repository);

  Future<Either<CommonError, UserModel>> execute(UserModel user) {
    return _repository.createUser(user);
  }
}
