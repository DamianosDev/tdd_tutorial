import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:http/http.dart' as http;
import 'package:tdd_tutorial/core/errors/exception.dart';
import 'package:tdd_tutorial/core/utils/constants.dart';
import 'package:tdd_tutorial/src/authentication/data/datasource/authentication_remote_data_source.dart';
import 'package:tdd_tutorial/src/authentication/data/models/user_model.dart';

class MockClient extends Mock implements http.Client {}

void main() {
  late http.Client client;
  late AuthenticationRemoteDataSource remoteDataSource;

  setUp(() {
    client = MockClient();
    remoteDataSource = AuthRemoteDataImpl(client);
    registerFallbackValue(Uri());
  });

  group('createUser', () {
    test('Should complete successfully', () async {
      // arrange
      when(
        () => client.post(
          any(),
          body: any(named: 'body'),
          headers: any(named: 'headers'),
        ),
      ).thenAnswer(
        (invocation) async => http.Response(
          'User create successfully',
          201,
        ),
      );
      // act
      final methodCall = remoteDataSource.createUser;

      // assert

      expect(
          methodCall(
            name: 'name',
            avatar: 'avatar',
            createdAt: 'createdAt',
          ),
          completes);
      verify(
        () => client.post(
          Uri.https(kBaseUrl, kCreateUserEndpoint),
          body: jsonEncode(
            {
              'name': 'name',
              'avatar': 'avatar',
              'createdAt': 'createdAt',
            },
          ),
          headers: {
            'Content-type': 'application/json',
          },
        ),
      ).called(1);

      verifyNoMoreInteractions(client);
    });

    test('Should throw [ApiExecution] when the status code is not 200 or 201',
        () async {
      // arrange
      when(
        () => client.post(
          any(),
          body: any(named: 'body'),
          headers: any(named: 'body'),
        ),
      ).thenAnswer(
        (invocation) async => http.Response(
          "type 'Null' is not a subtype of type 'Future<Response>'",
          505,
        ),
      );

      // act
      final methodCall = remoteDataSource.createUser;

      // assert
      expect(
        () async => methodCall(
          name: 'name',
          avatar: 'avatar',
          createdAt: 'createdAt',
        ),
        throwsA(const APIException(
          message: "type 'Null' is not a subtype of type 'Future<Response>'",
          statusCode: 505,
        )),
      );
      verify(
        () => client.post(
          Uri.https(kBaseUrl, kCreateUserEndpoint),
          body: jsonEncode(
            {
              'name': 'name',
              'avatar': 'avatar',
              'createdAt': 'createdAt',
            },
          ),
          headers: {
            'Content-type': 'application/json',
          },
        ),
      ).called(1);
      verifyNoMoreInteractions(client);
    });
  });

  group('getUsers', () {
    const tUsers = [UserModel.empty()];
    test(
      'Should return [List<User>] when the status code is 200',
      () async {
        // arrange
        when(
          () => client.get(
            any(),
          ),
        ).thenAnswer(
          (invocation) async => http.Response(
            jsonEncode([tUsers.first.toMap()]),
            200,
          ),
        );

        // act
        final result = await remoteDataSource.getUsers();

        // assert
        expect(result, equals(tUsers));

        verify(
          () => client.get(
            Uri.https(kBaseUrl, kGetUserEndpoint),
          ),
        ).called(1);
        verifyNoMoreInteractions(client);
      },
    );

    const tMessage = 'Server down Ahhhhh';

    test('Should return [List<User>] when the status code is not 200',
        () async {
      // arrange
      when(() => client.get(any())).thenAnswer(
        (invocation) async => http.Response(
          tMessage,
          500,
        ),
      );

      // act
      final methodCall = remoteDataSource.getUsers;

      // assert
      expect(
        () async => methodCall(),
        throwsA(
          const APIException(
            message: tMessage,
            statusCode: 500,
          ),
        ),
      );

      verify(
        () => client.get(
          Uri.https(kBaseUrl, kGetUserEndpoint),
        ),
      ).called(1);
      verifyNoMoreInteractions(client);
    });
  });
}
