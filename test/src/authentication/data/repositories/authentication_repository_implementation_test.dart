import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tdd_tutorial/core/errors/exception.dart';
import 'package:tdd_tutorial/core/errors/failure.dart';
import 'package:tdd_tutorial/src/authentication/data/datasource/authentication_remote_data_source.dart';
import 'package:tdd_tutorial/src/authentication/data/repositories/authentication_repository_implementation.dart';
import 'package:tdd_tutorial/src/authentication/domain/entities/user.dart';

class MockAuthRemoteDataSrc extends Mock
    implements AuthenticationRemoteDataSource {}

void main() {
  late AuthenticationRemoteDataSource remoteDataSource;
  late AuthenticationRepositoryImplementation repoImpl;

  setUp(() {
    remoteDataSource = MockAuthRemoteDataSrc();
    repoImpl = AuthenticationRepositoryImplementation(remoteDataSource);
  });

  group("createUser", () {
    const name = 'whatever.name';
    const avatar = 'whatever.avatar';
    const createdAt = 'whatever.createdAt';

    const tException = APIException(
      message: 'Unknown Error Occurred',
      statusCode: 500,
    );

    test(
        'Should call the [RemoteDataSource.createUser] and complete'
        ' successfully when the call to the remote source is successful',
        () async {
      // arrange
      when(() => remoteDataSource.createUser(
              name: any(named: 'name'),
              avatar: any(named: 'avatar'),
              createdAt: any(named: 'createdAt')))
          .thenAnswer((invocation) async => Future.value());

      // act
      final result = await repoImpl.createUser(
        name: name,
        avatar: avatar,
        createdAt: createdAt,
      );

      // assert
      expect(result, equals(const Right(null)));
      verify(() => remoteDataSource.createUser(
            name: name,
            avatar: avatar,
            createdAt: createdAt,
          )).called(1);
    });

    test(
        'Should return a [APIFailure] when the call to the remote '
        'source is unsuccessful', () async {
      // arrange
      when(() => remoteDataSource.createUser(
            name: any(named: 'name'),
            avatar: any(named: 'avatar'),
            createdAt: any(named: 'createdAt'),
          )).thenThrow(
        tException,
      );

      // act
      final result = await repoImpl.createUser(
        name: name,
        avatar: avatar,
        createdAt: createdAt,
      );

      // assert
      expect(
        result,
        equals(
          Left(
            APIFailure(
              message: tException.message,
              statusCode: tException.statusCode,
            ),
          ),
        ),
      );

      verify(() => remoteDataSource.createUser(
            name: name,
            avatar: avatar,
            createdAt: createdAt,
          )).called(1);

      verifyNoMoreInteractions(remoteDataSource);
    });
  });

  group("getUser", () {
    const tException = APIException(
      message: 'Unknown Error Occurred',
      statusCode: 500,
    );

    test(
        "should call the [RemoteDataSource.getUser] and return [List<User>]"
        " when call to remote source is successfully", () async {
      // arrange
      when(() => remoteDataSource.getUsers()).thenAnswer(
        (invocation) async => [],
      );

      // act
      final result = await repoImpl.getUsers();

      // assert
      expect(result, isA<Right<dynamic, List<User>>>());

      verify(() => remoteDataSource.getUsers()).called(1);

      verifyNoMoreInteractions(remoteDataSource);
    });

    test(
        'Should return a [APIFailure] when the call to the remote '
        'source is unsuccessful', () async {
      // arrange
      when(() => remoteDataSource.getUsers()).thenThrow(tException);

      // act
      final result = await repoImpl.getUsers();

      // assert
      expect(
          result,
          equals(
            left(
              APIFailure.fromException(tException),
            ),
          ));
      verify(() => remoteDataSource.getUsers()).called(1);
      verifyNoMoreInteractions(remoteDataSource);
    });
  });
}
