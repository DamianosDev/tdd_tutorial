import 'package:dartz/dartz.dart';
import 'package:tdd_tutorial/core/errors/exception.dart';
import 'package:tdd_tutorial/core/errors/failure.dart';
import 'package:tdd_tutorial/core/utils/typedef.dart';
import 'package:tdd_tutorial/src/authentication/data/datasource/authentication_remote_data_source.dart';
import 'package:tdd_tutorial/src/authentication/domain/entities/user.dart';
import 'package:tdd_tutorial/src/authentication/domain/repositories/authentication_repository.dart';

class AuthenticationRepositoryImplementation
    implements AuthenticationRepository {
  final AuthenticationRemoteDataSource _remoteDataSource;

  const AuthenticationRepositoryImplementation(this._remoteDataSource);

  @override
  ResultVoid createUser({
    required name,
    required avatar,
    required createdAt,
  }) async {
    try {
      await _remoteDataSource.createUser(
        name: name,
        avatar: avatar,
        createdAt: createdAt,
      );

      return const Right(null);
    } on APIException catch (e) {
      return Left(
        APIFailure.fromException(e),
      );
    }
  }

  @override
  ResultFuture<List<User>> getUsers() async {
    try {
      final result = await _remoteDataSource.getUsers();
      return Right(result);
    } on APIException catch (e) {
      return Left(
        APIFailure.fromException(e),
      );
    }
  }
}
