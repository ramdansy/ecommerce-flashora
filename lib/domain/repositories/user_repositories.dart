import 'package:either_dart/either.dart';

import '../../core/common/common_error.dart';
import '../../data/models/response/user_response.dart';
import '../entities/user_model.dart';

abstract class UserRepositories {
  Future<Either<CommonError, UserResponse>> getUserId(String userId);
  Future<Either<CommonError, UserModel>> createUser(UserModel user);
}
