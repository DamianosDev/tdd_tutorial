import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tdd_tutorial/src/authentication/domain/entities/user.dart';
import 'package:tdd_tutorial/src/authentication/domain/usecases/create_user.dart';
import 'package:tdd_tutorial/src/authentication/domain/usecases/get_users.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final CreateUser _createUser;
  final GetUsers _getUser;

  AuthenticationBloc({
    required CreateUser createUser,
    required GetUsers getUser,
  })  : _createUser = createUser,
        _getUser = getUser,
        super(const AuthenticationInitial()) {
    on<CreateUserEvent>(_createUserHandle);
    on<GetUsersEvent>(_getUserHandle);
  }

  Future<void> _createUserHandle(
      CreateUserEvent event, Emitter<AuthenticationState> emit) async {
    emit(const CreatingUser());

    final result = await _createUser(
      CreateUserParams(
        name: event.name,
        createdAt: event.createdAt,
        avatar: event.avatar,
      ),
    );

    result.fold(
      (failure) => emit(
        AuthenticationError(failure.errorMessage),
      ),
      (r) => emit(const UserCreated()),
    );
  }

  Future<void> _getUserHandle(
      GetUsersEvent event, Emitter<AuthenticationState> emit) async {
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
