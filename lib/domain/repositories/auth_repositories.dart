import 'package:either_dart/either.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../core/common/common_error.dart';

abstract class AuthRepositories {
  Future<Either<CommonError, User?>> loginWithEmailAndPassword(
      String email, String password);
  Future<Either<CommonError, User?>> registerWithEmailAndPassword(
      String email, String password);
}
