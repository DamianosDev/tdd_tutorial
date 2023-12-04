import 'dart:convert';

import 'package:tdd_tutorial/core/errors/exception.dart';
import 'package:tdd_tutorial/core/utils/constants.dart';
import 'package:tdd_tutorial/core/utils/typedef.dart';
import 'package:tdd_tutorial/src/authentication/data/models/user_model.dart';
import 'package:http/http.dart' as http;

abstract class AuthenticationRemoteDataSource {
  Future<void> createUser({
    required name,
    required avatar,
    required createdAt,
  });

  Future<List<UserModel>> getUsers();
}

const kCreateUserEndpoint = '/api/v1/users';
const kGetUserEndpoint = '/api/v1/users';

class AuthRemoteDataImpl implements AuthenticationRemoteDataSource {
  final http.Client _client;

  const AuthRemoteDataImpl(this._client);

  @override
  Future<void> createUser({
    required name,
    required avatar,
    required createdAt,
  }) async {
    try {
      final response = await _client.post(
        Uri.https(kBaseUrl, kCreateUserEndpoint),
        body: jsonEncode(
          {
            'name': name,
            'avatar': avatar,
            'createdAt': createdAt,
          },
        ),
        headers: {
          'Content-type': 'application/json',
        },
      );

      if (![200, 201].contains(response.statusCode)) {
        throw APIException(
          message: response.body,
          statusCode: response.statusCode,
        );
      }
    } on APIException {
      rethrow;
    } catch (e) {
      throw APIException(
        message: e.toString(),
        statusCode: 505,
      );
    }
  }

  @override
  Future<List<UserModel>> getUsers() async {
    try {
      final response = await _client.get(
        Uri.https(kBaseUrl, kGetUserEndpoint),
      );

      if (response.statusCode != 200) {
        throw APIException(
          message: response.body,
          statusCode: response.statusCode,
        );
      }

      return List<DataMap>.from(
        jsonDecode(response.body) as List,
      )
          .map(
            (userData) => UserModel.fromMap(userData),
          )
          .toList();
    } on APIException {
      rethrow;
    } catch (e) {
      throw APIException(
        message: e.toString(),
        statusCode: 505,
      );
    }
  }
}
