import 'package:either_dart/either.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../core/common/common_error.dart';
import '../../repositories/auth_repositories.dart';

class LoginUsecase {
  final AuthRepositories _repository;
  LoginUsecase(this._repository);

  Future<Either<CommonError, User?>> execute(String email, String password) {
    return _repository.loginWithEmailAndPassword(email, password);
  }
}
