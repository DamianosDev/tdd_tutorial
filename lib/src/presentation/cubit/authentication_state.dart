part of 'authentication_cubit.dart';

abstract class AuthenticationState extends Equatable {
  const AuthenticationState();

  @override
  List<Object> get props => [];
}

class AuthenticationInitial extends AuthenticationState {
  const AuthenticationInitial();
}

class CreatingUser extends AuthenticationState {
  const CreatingUser();
}

class GettingUser extends AuthenticationState {
  const GettingUser();
}

class UserCreated extends AuthenticationState {
  const UserCreated();
}

class UserLoaded extends AuthenticationState {
  final List<User> users;

  const UserLoaded(this.users);

  @override
  List<Object> get props => users
      .map(
        (user) => user.id,
      )
      .toList();
}

class AuthenticationError extends AuthenticationState {
  final String message;

  const AuthenticationError(this.message);

  @override
  List<Object> get props => [message];
}
