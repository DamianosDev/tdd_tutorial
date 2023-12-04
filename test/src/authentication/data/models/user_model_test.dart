import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:tdd_tutorial/src/authentication/data/models/user_model.dart';
import 'package:tdd_tutorial/src/authentication/domain/entities/user.dart';

import '../../../../fixtures/fixture_render.dart';

void main() {
  const tModel = UserModel.empty();
  final tJson = fixtures('user.json');
  final tMap = jsonDecode(tJson);

  test('Should be subclass of [User] entity', () {
    // Arrange
    // Act

    // Assert
    expect(tModel, isA<User>());
  });

  group('fromMap', () {
    test('Should return [UserModel] with the right data', () {
      // Arrange

      // Art
      final result = UserModel.fromMap(tMap as Map<String, dynamic>);

      // assert
      expect(result, equals(tModel));
    });
  });

  group('fromJson', () {
    test('Should return [UserModel] with the right data', () {
      // Arrange

      // Art
      final result = UserModel.fromJson(tJson);

      // assert
      expect(result, equals(tModel));
    });
  });

  group('toJson', () {
    test('Should return [UserModel] with the right data', () {
      // Arrange

      // Art
      final result = tModel.toJson();
      final tJson = jsonEncode(
        {
          'id': '1',
          'name': '_empty.name',
          'avatar': '_empty.avatar',
          'createdAt': '_empty.createdAt',
        },
      );

      // assert
      expect(result, equals(tJson));
    });
  });

  group('copyWith', () {
    test('Should return a [UserModel] with different data', () {
      final result = tModel.copyWith(name: 'Than');
      expect(result.name, equals('Than'));
    });
  });
}
