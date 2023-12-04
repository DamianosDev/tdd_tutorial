import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tdd_tutorial/core/errors/failure.dart';
import 'package:tdd_tutorial/src/authentication/domain/usecases/create_user.dart';
import 'package:tdd_tutorial/src/authentication/domain/usecases/get_users.dart';
import 'package:tdd_tutorial/src/presentation/cubit/authentication_cubit.dart';

class MockCreateUser extends Mock implements CreateUser {}

class MockGetUser extends Mock implements GetUsers {}

void main() {
  late CreateUser createUser;
  late GetUsers getUsers;
  late AuthenticationCubit cubit;

  const tCreateUserParams = CreateUserParams.empty();
  const tApiFailure = APIFailure(message: 'message', statusCode: 400);

  setUp(() {
    createUser = MockCreateUser();
    getUsers = MockGetUser();
    cubit = AuthenticationCubit(
      createUser: createUser,
      getUsers: getUsers,
    );
    registerFallbackValue(tCreateUserParams);
  });

  tearDown(
    () => cubit.close(),
  );

  test('initial state should be [AuthenticationInitial]', () {
    expect(cubit.state, const AuthenticationInitial());
  });

  group('createUser', () {
    blocTest<AuthenticationCubit, AuthenticationState>(
      'should emit [CreatingUser, UserCreated] when successful',
      build: () {
        when(() => createUser(any())).thenAnswer(
          (invocation) async => const Right(null),
        );
        return cubit;
      },
      act: (cubit) => cubit.createUser(
        name: tCreateUserParams.name,
        avatar: tCreateUserParams.avatar,
        createdAt: tCreateUserParams.createdAt,
      ),
      expect: () => const [
        CreatingUser(),
        UserCreated(),
      ],
      verify: (_) {
        verify(() => createUser(tCreateUserParams)).called(1);
        verifyNoMoreInteractions(createUser);
      },
    );

    blocTest<AuthenticationCubit, AuthenticationState>(
      'should emit [CreatingUser, AuthenticationError] when unsuccessful',
      build: () {
        when(() => createUser(any())).thenAnswer(
          (invocation) async => const Left(tApiFailure),
        );
        return cubit;
      },
      act: (cubit) => cubit.createUser(
        name: tCreateUserParams.name,
        avatar: tCreateUserParams.avatar,
        createdAt: tCreateUserParams.createdAt,
      ),
      expect: () => [
        const CreatingUser(),
        AuthenticationError(tApiFailure.errorMessage),
      ],
      verify: (_) {
        verify(() => createUser(tCreateUserParams)).called(1);
        verifyNoMoreInteractions(createUser);
      },
    );
  });

  group('getUser', () {
    blocTest<AuthenticationCubit, AuthenticationState>(
      'should emit [GettingUser, UserLoaded] when successful',
      build: () {
        when(() => getUsers()).thenAnswer(
          (invocation) async => const Right([]),
        );
        return cubit;
      },
      act: (cubit) => cubit.getUsers(),
      expect: () => const [
        GettingUser(),
        UserLoaded([]),
      ],
      verify: (_) {
        verify(() => getUsers()).called(1);
        verifyNoMoreInteractions(getUsers);
      },
    );

    blocTest<AuthenticationCubit, AuthenticationState>(
      'should emit [GettingUser, AuthenticationError] when unsuccessful',
      build: () {
        when(() => getUsers()).thenAnswer(
          (invocation) async => const Left(tApiFailure),
        );
        return cubit;
      },
      act: (cubit) => cubit.getUsers(),
      expect: () => [
        const GettingUser(),
        AuthenticationError(tApiFailure.errorMessage),
      ],
      verify: (_) {
        verify(() => getUsers()).called(1);
        verifyNoMoreInteractions(getUsers);
      },
    );
  });
}
