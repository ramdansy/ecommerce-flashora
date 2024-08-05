import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:either_dart/either.dart';

import '../../core/common/common_error.dart';
import '../../domain/entities/user_model.dart';
import '../../domain/repositories/user_repositories.dart';
import '../datasources/user_datasource.dart';
import '../models/response/user_response.dart';

class UserRepositoriesImpl implements UserRepositories {
  final UserDatasource dataSource;

  UserRepositoriesImpl({required this.dataSource});

  @override
  Future<Either<CommonError, UserResponse>> getUserId(String userId) async {
    try {
      final response = await dataSource.getUserId(userId);

      if (response.exists) {
        return Right(UserResponse.fromMap(response.data()!)
            .copyWith(docId: response.id));
      } else {
        return Left(CommonError(message: 'Failed to load user data'));
      }
    } catch (e) {
      return Left(CommonError(message: 'Unknown error: $e'));
    }
  }

  @override
  Future<Either<CommonError, UserModel>> createUser(UserModel user) async {
    try {
      final response = await dataSource.createUser(user);

      DocumentSnapshot<Map<String, dynamic>> result = await response.get();

      if (result.exists) {
        return Right(UserModel.fromMap(result.data()!));
      } else {
        return Left(CommonError(message: 'Failed to create user data'));
      }
    } catch (e) {
      return Left(CommonError(message: 'Unknown error: $e'));
    }
  }
}
