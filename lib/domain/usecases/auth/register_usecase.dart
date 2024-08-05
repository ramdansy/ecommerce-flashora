import 'package:either_dart/either.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../core/common/common_error.dart';
import '../../repositories/auth_repositories.dart';

class RegisterUsecase {
  final AuthRepositories _repository;
  RegisterUsecase(this._repository);

  Future<Either<CommonError, User?>> execute(String email, String password) {
    return _repository.registerWithEmailAndPassword(email, password);
  }
}
