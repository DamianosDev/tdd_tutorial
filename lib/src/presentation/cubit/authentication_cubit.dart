import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tdd_tutorial/src/authentication/domain/entities/user.dart';
import 'package:tdd_tutorial/src/authentication/domain/usecases/create_user.dart';
import 'package:tdd_tutorial/src/authentication/domain/usecases/get_users.dart';

part 'authentication_state.dart';

class AuthenticationCubit extends Cubit<AuthenticationState> {
  final CreateUser _createUser;
  final GetUsers _getUser;
  AuthenticationCubit({
    required CreateUser createUser,
    required GetUsers getUsers,
  })  : _createUser = createUser,
        _getUser = getUsers,
        super(const AuthenticationInitial());

  Future<void> createUser({
    required String name,
    required String avatar,
    required String createdAt,
  }) async {
    emit(const CreatingUser());

    final result = await _createUser(
      CreateUserParams(
        name: name,
        createdAt: createdAt,
        avatar: avatar,
      ),
    );

    result.fold(
      (failure) => emit(
        AuthenticationError(failure.errorMessage),
      ),
      (_) => emit(
        const UserCreated(),
      ),
    );
  }

  Future<void> getUsers() async {
    emit(const GettingUser());

    final result = await _getUser();

    result.fold(
      (failure) => emit(
        AuthenticationError(failure.errorMessage),
      ),
      (users) => emit(UserLoaded(users)),
    );
  }
}
