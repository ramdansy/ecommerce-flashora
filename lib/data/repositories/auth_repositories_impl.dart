import 'package:either_dart/either.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../core/common/common_error.dart';
import '../../core/common/enum/common_error_type.dart';
import '../../domain/repositories/auth_repositories.dart';
import '../datasources/auth_datasource.dart';

class AuthRepositoriesImpl implements AuthRepositories {
  final AuthDatasource dataSource;

  AuthRepositoriesImpl({required this.dataSource});

  @override
  Future<Either<CommonError, User?>> loginWithEmailAndPassword(
      String email, String password) async {
    try {
      final response =
          await dataSource.loginWithEmailAndPassword(email, password);

      return Right(response.user);
    } on FirebaseAuthException catch (e) {
      return Left(CommonError(
        errorType: CommonErrorType.unknownException,
        error: e,
        message: 'Email or password is incorrect',
      ));
    } catch (e) {
      return Left(CommonError(
        errorType: CommonErrorType.unknownException,
        message: 'Unknow Error: $e',
      ));
    }
  }

  @override
  Future<Either<CommonError, User?>> registerWithEmailAndPassword(
      String email, String password) async {
    try {
      final response =
          await dataSource.registerWithEmailAndPassword(email, password);

      return Right(response.user);
    } on FirebaseAuthException catch (e) {
      String message = 'Email or password is incorrect';
      switch (e.code) {
        case 'email-already-in-use':
          message = 'Email already in use';
          break;
        case 'weak-password':
          message = 'Password is too weak';
          break;
      }

      return Left(CommonError(
        errorType: CommonErrorType.unknownException,
        error: e,
        message: message,
      ));
    } catch (e) {
      return Left(CommonError(
        errorType: CommonErrorType.unknownException,
        message: 'Unknow Error: $e',
      ));
    }
  }
}
